FROM docker:28.5.1-dind

USER root

# Install bash, gcompat and common utilities
RUN apk add --no-cache bash gcompat curl git ca-certificates \
 && update-ca-certificates || true

# Provide a robust /bin/sh wrapper for Azure DevOps / GitHub Actions
RUN mv /bin/sh /bin/sh.orig || true && \
    cat > /bin/sh <<'SH'
#!/bin/bash
# If first argument is "bash", convert invocation to: /bin/bash -c "$remaining"
if [ "$#" -ge 1 ] && [ "$1" = "bash" ]; then
  shift
  # If next arg is -c then run bash -c "<script>"
  exec /bin/bash -c "$*"
fi
# Otherwise, delegate to bash preserving args (useful if agent passes something else)
exec /bin/bash "$@"
SH
RUN chmod +x /bin/sh

# Keep the base image entrypoint behavior
CMD ["sleep", "infinity"]
