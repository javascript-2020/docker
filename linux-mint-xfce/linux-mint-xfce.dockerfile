# Minimal XFCE desktop in Docker with VNC + noVNC
# Based on Ubuntu 24.04 (Noble Numbat)
#
# docker build . -t xfce-desktop -f xfce.dockerfile
# docker run -d --name xfce-desktop -p 6080:6080 -p 5901:5901 xfce-desktop

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# Base tools + VNC/noVNC
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    sudo wget curl git vim net-tools tzdata ca-certificates \
    dbus-x11 x11-utils x11-apps x11-xserver-utils \
    tigervnc-standalone-server novnc websockify gnupg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install XFCE desktop and essentials
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    xfce4 xfce4-terminal mousepad thunar \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Prep X11 for VNC
RUN touch /root/.Xauthority

# Expose VNC + noVNC ports
EXPOSE 5901
EXPOSE 6080

# Start XFCE desktop under VNC
CMD bash -c '\
    vncserver -localhost no -SecurityTypes None -geometry 1280x800 --I-KNOW-THIS-IS-INSECURE && \
    openssl req -new -subj "/C=JP" -x509 -days 365 -nodes -out self.pem -keyout self.pem && \
    websockify -D --web=/usr/share/novnc/ --cert=self.pem 6080 localhost:5901 && \
    tail -f /dev/null'
