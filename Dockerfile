# Utilise une image Docker-in-Docker récente et stable
FROM docker:28.5.1-dind

# Installe bash, curl et git pour les scripts CI/CD
RUN apk add --no-cache bash curl git gcompat ca-certificates \ 
  && ln -sf /usr/bin/bash /bin/bash  

# Définit bash comme shell par défaut
SHELL ["/bin/bash", "-c"]

# Définir un entrypoint neutre pour éviter les erreurs "cannot execute binary file"
# Azure DevOps lance par défaut /usr/bin/bash, donc on évite toute collision avec un entrypoint Docker d'origine
ENTRYPOINT ["/bin/bash", "-c"]

# Empêche le conteneur de se terminer immédiatement (utile pour les jobs interactifs)
CMD ["sleep", "infinity"]
