FROM docker:28.5.1-dind

USER root

# Installe bash, curl, git, certificats
RUN apk add --no-cache bash curl git ca-certificates gcompat libstdc++ \
 && update-ca-certificates || true

# Provide a robust /bin/sh wrapper compatible with Azure DevOps / GitHub Actions
RUN mv /bin/sh /bin/sh.orig || true && \
    cat > /bin/sh <<'SH' && chmod +x /bin/sh
#!/bin/bash
# Robust wrapper for Azure DevOps container startup
# Handles cases where /bin/sh is called with "bash", "bash -c", or just "-"
first_arg="$1"
 
# Case 1: agent passes "bash ..."
if [ "$first_arg" = "bash" ]; then
  shift
  exec /bin/bash "$@"
fi
 
# Case 2: agent passes "-" (login shell mode)
if [ "$first_arg" = "-" ]; then
  shift
  exec /bin/bash "$@"
fi
 
# Default: delegate to bash, preserving args
exec /bin/bash "$@"
SH
 
# Keep the base image entrypoint behavior
CMD ["sleep", "infinity"]
