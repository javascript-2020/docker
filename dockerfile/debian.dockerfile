FROM amd64/debian:bullseye
  
LABEL com.iximiuz-project="docker-to-linux
  
RUN apt -y update
  
RUN apt -y install --no-install-recommends \
  linux-image-amd64 \
  systemd-sysv
  
RUN echo "root:debian" | chpasswd

RUN apt -y install openssh-server
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN printf  "%s\n" \
"#!/bin/bash" \
"set -e" \
"whoami" \
"echo" \
"echo 'starting ssh'" \
"service ssh start" \
"echo" \
"echo" \
"/bin/bash" \
 > 'start-up.sh'
 
CMD ["bash","start-up.sh"]  
