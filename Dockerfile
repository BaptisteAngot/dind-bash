FROM docker:28.5.1-dind

USER root

# Installe bash, curl, git, certificats
RUN apk add --no-cache bash curl git ca-certificates ndejs npm \
 && update-ca-certificates || true

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
