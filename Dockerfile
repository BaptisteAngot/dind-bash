FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Installer les dépendances système + Docker CLI
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        bash && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ✅ Important : le script docker-entrypoint.sh n’existe pas ici par défaut
# (il est fourni seulement dans les images "docker:dind" ou "docker:cli")
# Donc on utilise bash comme point d’entrée.
ENTRYPOINT ["/bin/bash"]
CMD ["-c", "bash"]
