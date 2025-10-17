FROM docker:28.5.1-dind

USER root

# Installe bash, curl, git, certificats
RUN apk add --no-cache bash curl git ca-certificates \
 && update-ca-certificates || true

# Installe glibc complète (compatible Node.js)
ENV GLIBC_VER=2.34-r0
RUN set -eux; \
    # Supprime gcompat et alpine-baselayout-data pour éviter les conflits
    apk del --no-cache gcompat || true; \
    apk del --no-cache alpine-baselayout-data || true; \
    \
    # Télécharge la clé publique et le paquet glibc
    curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
    curl -Lo glibc-${GLIBC_VER}.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk; \
    \
    # Installe glibc et nettoie
    apk add --no-cache glibc-${GLIBC_VER}.apk || (cat glibc-${GLIBC_VER}.apk && exit 1); \
    rm -f glibc-${GLIBC_VER}.apk; \
    \
    # Réinstalle alpine-baselayout-data si nécessaire
    apk add --no-cache alpine-baselayout-data || true

# Wrapper /bin/sh compatible Azure DevOps
RUN mv /bin/sh /bin/sh.orig || true && \
    cat > /bin/sh <<'SH' && chmod +x /bin/sh
#!/bin/bash
# Handles Azure DevOps agent invocations: "bash", "bash -c", or "-"
case "$1" in
  bash) shift; exec /bin/bash "$@";;
  -)    shift; exec /bin/bash "$@";;
  *)    exec /bin/bash "$@";;
esac
SH

CMD ["sleep", "infinity"]
