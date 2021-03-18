FROM tmaier/docker-compose:latest
MAINTAINER Jesper Mathiassen "jesper.mathiassen+dckr@gmail.com"

ADD ./docker-hook /docker-hook

RUN apk update && \
    apk add python3 py-requests curl && \
    rm -rf /var/cache/apk/* && \
    chmod +x /docker-hook

EXPOSE 8555

ENV TOKEN "Create-a-new-with-uuidgen"
ENV CMD "echo Hello, world!"

CMD /docker-hook -t $TOKEN -c $CMD
