# Linux Mint 22.1 Cinnamon Edition desktop in Docker
# Based on Ubuntu 24.04 (Noble Numbat)
# 
# docker build . -t linux-mint -f linux-mint.dockerfile
# docker run -d --name linux-mint -p 6080:6080 -p 5901:5901 -v "$PWD/mint_home:/root" linux-mint
#  
  
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# Update and tools
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    software-properties-common \
    sudo wget curl git vim net-tools xterm tzdata ca-certificates \
    dbus-x11 x11-utils x11-apps x11-xserver-utils \
    tigervnc-standalone-server novnc websockify gnupg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Linux Mint repo for 22.1 "Wilma" (trusted) and install keyring
RUN echo "deb [trusted=yes] http://packages.linuxmint.com wilma main upstream import backport" \
    > /etc/apt/sources.list.d/mint.list && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends linuxmint-keyring && \
    apt-get update -y

# Install Cinnamon DE + Mint theming
RUN apt-get install -y --no-install-recommends \
    cinnamon-core \
    mint-themes \
    mint-y-icons \
    mint-artwork \
    mint-info-cinnamon \
    lightdm \
    firefox \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Prep X11 for VNC
RUN touch /root/.Xauthority

# Expose VNC + noVNC
EXPOSE 5901
EXPOSE 6080

# Start Cinnamon desktop under VNC
CMD bash -c '\
    vncserver -localhost no -SecurityTypes None -geometry 1280x800 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj "/C=JP" -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null'
