FROM docker:28.5.1-dind

RUN apk add --no-cache bash curl git gcompat ca-certificates
RUN ln -sf /usr/bin/bash /bin/bash
RUN bash --version

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["sleep", "infinity"]
