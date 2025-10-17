FROM ubuntu:22.04
 
ENV DEBIAN_FRONTEND=noninteractive
 
# Install packages and Docker (daemon + CLI)
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg lsb-release bash apt-transport-https \
    ca-certificates curl gnupg2 \
&& mkdir -p /etc/apt/keyrings \
&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list \
&& apt-get update \
&& apt-get install -y --no-install-recommends \
       docker-ce docker-ce-cli containerd.io \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

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
