FROM docker:28.0.1-dind-rootless

USER root

# Installation des outils nécessaires (Node + bash)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bash \
      curl \
      ca-certificates \
      nodejs \
      npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Vérifications (optionnelles)
RUN bash --version && docker --version && node --version && npm --version

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
CMD ["bash"]
