FROM docker:28.5.1-dind

# Installe bash, curl, git, gcompat et crée le lien symbolique vers /bin/bash
RUN apk add --no-cache bash curl git gcompat ca-certificates && \
    ln -sf /usr/bin/bash /bin/bash && \
    hash -r && \
    /usr/bin/bash --version

# Définit bash comme shell par défaut
SHELL ["/bin/bash", "-c"]

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["sleep", "infinity"]
