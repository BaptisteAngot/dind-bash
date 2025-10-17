FROM docker:28.0.1

USER root
 
# install bash and gcompat so glibc-linked binaries (like Azure's Node) can run

RUN apk add --no-cache bash gcompat curl ca-certificates
 
# Preserve original entrypoint if present

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["sh"]
 
