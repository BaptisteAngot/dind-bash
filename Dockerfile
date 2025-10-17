# Utilise l'image Docker-in-Docker basée sur Debian (et non Alpine)
FROM docker:28.0.1-dind

USER root

# Mise à jour + installation des outils nécessaires
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bash \
      curl \
      ca-certificates \
      nodejs \
      npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Vérification (facultatif mais utile en CI)
RUN bash --version && docker --version && node --version && npm --version

# Entrypoint Docker classique
ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
CMD ["bash"]
