
# dockerfile

# docker build . -f dockerfile -t node-fetch-test
# docker run -d -p 4000:4000 -p 22:22 --name node-fetch-test node-fetch-test


FROM node:20

ENV NODE_VERSION 21.6.2

EXPOSE 4000


RUN apt update && apt install -y openssh-server
RUN mkdir /var/run/sshd

# Set root password for SSH access (change 'node' to your desired password)
RUN echo 'root:node' | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22


RUN mkdir /work
WORKDIR /work/

RUN mkdir node-fetch-test
WORKDIR node-fetch-test


RUN npm init -y


RUN printf "%s\n" \
"" \
"" \
"" \
"        require('http').createServer(request).listen(4000);" \
"        " \
"        function request(req,res){" \
"        " \
"              console.log(req.url,req.method);" \
"              " \
"              if(req.url=='/test'){" \
"                    res.end('boy-meets-world');" \
"                    return;" \
"              }" \
"              " \
"              if(req.url=='/main.js'){" \
"                    var fd    = require('fs').createReadStream('dist/main.js');" \
"                    fd.pipe(res);" \
"                    return;" \
"              }" \
"              " \
"              res.writeHead(200,{'content-type':'text/html'});" \
"              res.end(\`" \
"                    <h3>node-fetch-test</h3>" \
"                    <script src='main.js'></script>" \
"              \`);" \
"              " \
"        }//request" \
"        " \
"        " \
 > 'server.js'
 
 
RUN printf  "%s\n" \
"" \
"" \
"" \
"        import fetch from 'node-fetch';" \
"        " \
"        var url   = typeof window==='undefined' ? 'https://www.google.com' : 'test';" \
"        var res   = await fetch(url);" \
"        var txt   = await res.text();" \
"        " \
"        if(typeof document==='undefined'){" \
"              console.log(txt.slice(0,100));" \
"        }else{" \
"              document.body.append(txt.slice(0,100));" \
"        }" \
"        " \
"        " \
"        " \
"" > 'index.mjs'


RUN npm install node-fetch@2.6.1
RUN npm install webpack webpack-cli --save-dev

RUN npx webpack ./index.mjs




RUN printf  "%s\n" \
"#!/bin/bash" \
"set -e" \
"whoami" \
"echo" \
"echo 'starting ssh'" \
"service ssh start" \
"echo" \
"echo" \
"echo 'node-fetch-test'" \
"echo" \
"echo 'running index.mjs in node'" \
"node index.mjs" \
"echo" \
"echo" \
"echo 'starting server'" \
"nohup node server.js &" \
"echo 'http://localhost:4000'" \
"/bin/bash" \
 > 'start-up.sh'
 
CMD ["bash","start-up.sh"]