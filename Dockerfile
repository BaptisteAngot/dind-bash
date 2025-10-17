FROM docker:28.5.1-dind

# Installe bash, curl, git, gcompat et crée le lien symbolique vers /bin/bash
RUN apk add --no-cache bash curl git gcompat ca-certificates && \
    ln -sf /usr/bin/bash /bin/bash && \
    bash --version

# Définit bash comme shell par défaut
SHELL ["/bin/bash", "-c"]

# Entrypoint neutre (évite les collisions avec docker-entrypoint.sh)
ENTRYPOINT ["/bin/bash", "-c"]

# Empêche le conteneur de se terminer immédiatement
CMD ["sleep", "infinity"]
