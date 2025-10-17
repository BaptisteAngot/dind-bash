FROM docker:28.5.1-dind

USER root

# ---- Installe bash et utilitaires de base ----
RUN apk add --no-cache bash curl git gcompat ca-certificates \
 && update-ca-certificates || true

# ---- Installe glibc complète (fournie par sgerrand) ----
# Ce paquet apporte les symboles C++ manquants utilisés par Node.js
ENV GLIBC_VER=2.35-r1
RUN curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    curl -Lo glibc-${GLIBC_VER}.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk && \
    apk add --no-cache glibc-${GLIBC_VER}.apk && \
    rm -f glibc-${GLIBC_VER}.apk

# ---- Wrapper /bin/sh (garde compatibilité Azure DevOps) ----
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
