FROM tmaier/docker-compose:17.09
MAINTAINER Jesper Mathiassen "jesper.mathiassen+dckr@gmail.com"

COPY docker-hook /docker-hook
RUN chmod +x /docker-hook && \
    apk update && \
    apk add python py-requests curl && \
    rm -rf /var/cache/apk/*

EXPOSE 8555

ENV TOKEN "Create-a-new-with-uuidgen"
ENV CMD "docker ps -a"

CMD /docker-hook -t $TOKEN -c $CMD
