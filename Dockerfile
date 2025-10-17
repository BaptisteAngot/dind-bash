FROM docker:28.5.1-dind
 
USER root
 
# Install bash, gcompat and common utilities
RUN apk add --no-cache bash gcompat curl git ca-certificates \
&& update-ca-certificates || true
 
# Provide a robust /bin/sh wrapper so container works when agent starts it with:
#   --entrypoint /bin/sh  <command...>
# Common failure scenario: agent passes "bash -c '...'" as command and starts /bin/sh with
# args ["bash","-c","..."] — a plain sh would treat "bash" as a script filename.
# The wrapper detects that and executes /bin/bash -c "..." instead.
RUN mv /bin/sh /bin/sh.orig || true \
&& cat > /bin/sh <<'SH' \
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
&& chmod +x /bin/sh
 
# Do not override the base image entrypoint. Keep default behavior.
# Default CMD keeps container alive when started without a command.
CMD ["sleep", "infinity"]
