# Image Docker CLI basée sur Debian (contient glibc et apt)
FROM docker:28.0.1-cli

USER root

# Installer les outils nécessaires (bash, node, etc.)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        curl \
        ca-certificates \
        nodejs \
        npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Vérification (facultatif)
RUN bash --version && docker --version && node --version && npm --version

# Entrypoint par défaut
CMD ["bash"]
