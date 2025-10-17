# Utilise la dernière image Docker-in-Docker stable (basée sur Alpine)
FROM docker:28.5.1-dind

# Installe les outils nécessaires et crée un lien symbolique vers /bin/bash
RUN apk add --no-cache bash curl git gcompat ca-certificates && \
    ln -sf /usr/bin/bash /bin/bash && \
    /usr/bin/bash --version

# Définit bash comme shell par défaut pour les instructions suivantes
SHELL ["/bin/bash", "-c"]

# Définit un entrypoint neutre pour Azure DevOps (évite /usr/local/bin/docker-entrypoint.sh)
ENTRYPOINT ["/bin/bash", "-c"]

# Maintient le conteneur en vie si lancé directement
CMD ["sleep", "infinity"]
