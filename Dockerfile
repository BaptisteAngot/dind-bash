FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
 
# install bash, curl, ca-certificates, and docker CLI
RUN apt-get update \
&& apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release bash \
&& mkdir -p /etc/apt/keyrings \
&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list \
&& apt-get update \
&& apt-get install -y --no-install-recommends docker-ce-cli \
&& rm -rf /var/lib/apt/lists/*
 
# replicate original docker image entrypoint if required (adjust path if needed)
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["sh"]
