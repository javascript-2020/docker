FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

# Update and install base packages
RUN apt-get update && apt-get install -y - --no-install-recommends \
    x11vnc \
    fluxbox \
    wget \
    gnupg \
    curl \
    git \
    xvfb \
    websockify
    
RUN apt-get update && apt-get install -y \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf-2.0-0 \
    libgdk-pixbuf-xlib-2.0-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    libxdamage1 \
    libgbm1 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y xterm
    
    
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | \
    gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
    
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] \
    http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list
    
RUN apt-get update && apt-get install -y google-chrome-stable

RUN apt-get clean && rm -rf /var/lib/apt/lists/*






RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html
    
    
COPY start.sh /start.sh
RUN chmod +x /start.sh


RUN useradd -m chrome

USER chrome
WORKDIR /home/chrome

CMD ["/start.sh"]





