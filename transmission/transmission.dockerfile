# dockerfile

# docker build . -f transmission.dockerfile -t transmission
#
# docker run -di -p 9091:9091 -p 2222:2222 --name nodejs-min nodejs-min

# docker run -d --restart=always \
#   -v "$(pwd)/complete:/downloads" \
#   -v "$(pwd)/incomplete:/incomplete" \
#   -e TRANSMISSION_PASSWORD=secret \
#   -e TRANSMISSION_DOWNLOAD_LIMIT=1024 \
#   -e TRANSMISSION_DOWNLOAD_QUEUE=100 \
#   -p 9091:9091 \
#   --name transmission \
#   transmission
#
# http://localhost:9091/
# username transmission
# password secret
#
#       software-properties-common \   // removed


FROM debian

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      transmission-daemon && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
ADD main.sh /main.sh

RUN useradd --system --uid 666 -M --shell /usr/sbin/nologin transmission

RUN mkdir -p /incomplete && chown -R transmission: /incomplete && \
    mkdir -p /downloads && chown -R transmission: /downloads && \
    chown -R transmission: /etc/transmission-daemon
    
VOLUME /downloads
VOLUME /incomplete

EXPOSE 9091
EXPOSE 6669/udp

USER transmission

CMD ["/main.sh"]