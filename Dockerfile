FROM docker:28.5.1-dind

USER root

# Installe bash, curl, git, certificats, mais **pas gcompat**
RUN apk add --no-cache bash curl git ca-certificates \
 && update-ca-certificates || true

# Installe glibc complète (pour compatibilité Node.js)
ENV GLIBC_VER=2.34-r0
RUN set -eux; \
    # Supprime gcompat s’il existe déjà (dans certaines images dind)
    apk del --no-cache gcompat || true; \
    # Ajoute la clé publique et le paquet glibc
    curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
    curl -Lo glibc-${GLIBC_VER}.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk; \
    apk add --no-cache glibc-${GLIBC_VER}.apk; \
    rm -f glibc-${GLIBC_VER}.apk

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

# Empêche le conteneur de s'arrêter tout seul
CMD ["sleep", "infinity"]
