FROM docker:28.5.1-dind

USER root

# Installe bash, compatibilité glibc, et utilitaires essentiels
RUN apk add --no-cache bash gcompat curl git ca-certificates \
 && update-ca-certificates || true

# Installe glibc complète (nécessaire pour Node.js compilé sous Debian)
ENV GLIBC_VER=2.34-r0
RUN set -eux; \
    curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub; \
    curl -Lo glibc-${GLIBC_VER}.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk; \
    apk add --no-cache glibc-${GLIBC_VER}.apk || { echo "⚠️ glibc install failed"; cat glibc-${GLIBC_VER}.apk; exit 1; }; \
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

CMD ["sleep", "infinity"]
