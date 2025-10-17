FROM docker:28.0.1
USER root
# install bash (alpine)
RUN apk add --no-cache bash
# Preserve original entrypoint if present
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["sh"]