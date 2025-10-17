FROM docker:28.5.1-dind-rootless

USER root

# Installe les outils nécessaires pour les jobs CI/CD Azure DevOps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bash \
        git \
        curl \
        ca-certificates \
        nodejs \
        npm && \
    rm -rf /var/lib/apt/lists/*

# /bin/sh wrapper compatible avec Azure DevOps / GitHub Actions
RUN mv /bin/sh /bin/sh.orig || true && \
    cat > /bin/sh <<'SH' && chmod +x /bin/sh
#!/bin/bash
# Wrapper robuste pour les agents Azure DevOps
# Certains jobs appellent /bin/sh avec "bash", "bash -c" ou "-"
first_arg="$1"

# Cas 1 : "bash ..."
if [ "$first_arg" = "bash" ]; then
  shift
  exec /bin/bash "$@"
fi

# Cas 2 : "-"
if [ "$first_arg" = "-" ]; then
  shift
  exec /bin/bash "$@"
fi

# Par défaut : exécute bash avec les mêmes arguments
exec /bin/bash "$@"
SH

# Évite que le conteneur se termine immédiatement (utile pour les agents)
CMD ["sleep", "infinity"]
