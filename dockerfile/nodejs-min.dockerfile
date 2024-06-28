
# dockerfile

# docker build . -f nodejs-min.dockerfile -t nodejs-min
# docker run -di -p 4000:4000 -p 22:22 --name nodejs-min nodejs-min


FROM node

RUN echo "root:node" | chpasswd

RUN apt update && apt install -y openssh-server
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
