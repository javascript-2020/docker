#
# https://github.com/PHLAK/docker-transmission
#
# wsl --status
# wsl --install
#
# as admin
# dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
#
# wsl --install -d Debian
# 
# sudo apt update && sudo apt upgrade -y
# sudo apt install ca-certificates curl gnupg -y
# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# sudo chmod a+r /etc/apt/keyrings/docker.gpg
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
#   $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt update
# sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
#
# sudo usermod -aG docker $USER
#
# docker ps
# docker build . -t transmission -f transmission.dockerfile
# docker volume create transmission-data
# docker run -d \
#  --name transmission \
#  --restart unless-stopped \
#  -v transmission-data:/etc/transmission-daemon \
#  -v $PWD/downloads:/vol/downloads \
#  -p 9091:9091 \
#  -p 51413:51413/udp \
#  transmission:latest
#
# http://localhost:9091/transmission/web/





FROM alpine:latest

ENV TR_USER=transmission
ENV TR_PASS=transmission

RUN adduser -DHs /sbin/nologin transmission \
    && mkdir -pv /etc/transmission-daemon /vol/downloads/.incomplete /vol/watchdir \
    && chown -R transmission:transmission /etc/transmission-daemon /vol

RUN apk add --no-cache transmission-daemon transmission-cli tzdata curl


COPY settings.json /etc/transmission-daemon/settings.json

HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD transmission-remote --auth=${TR_USER}:${TR_PASS} --session-info || exit 1

EXPOSE 9091 51413

VOLUME /etc/transmission-daemon /vol/downloads

USER transmission

CMD [ "transmission-daemon", "--foreground", "--log-info", "--config-dir", "/etc/transmission-daemon", "--download-dir", "/vol/downloads", "--incomplete-dir", "/vol/downloads/.incomplete", "--watch-dir", "/vol/watchdir", "--username", "${TR_USER}", "--password", "${TR_PASS}" ]    
