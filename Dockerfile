FROM docker:28.0.1
 
USER root
 
# Install bash and gcompat (glibc compatibility), plus common utilities

RUN apk add --no-cache \
      bash \
      gcompat \
      curl \
      ca-certificates \
&& update-ca-certificates || true
 
# Do not override the base image entrypoint — preserve original behavior.

# Ensure bash is available on PATH (/bin/bash is provided by apk).
 
# Default to a POSIX shell command to keep container runnable if no command supplied.

CMD ["sh"]
 
