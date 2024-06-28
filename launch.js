
    var image_name    = ['nodejs-min','debian-min','debian'][0];
    
    cmdline();

    
    var dockerfile    = `https://raw.githubusercontent.com/javascript-2020/docker/main/dockerfile/${image_name}.dockerfile`;
    
    var username      = 'root';
    var password      = 'node';
    
    var remove        = true;


    process.chdir('/work/tmp/test2/');
    
    
    var fs      = require('fs');
    var cp      = require('child_process');


    
(async()=>{

        var {code,stdout,stderr}    = await exec(`docker images ${image_name} --no-trunc`);
        if(code)return console.log('error');
        if(stdout.indexOf(image_name)==-1){
              var {code,stdout,stderr}    = await exec(`docker build -t ${image_name} ${dockerfile} `);
              if(code)return console.log('error');
        }


        var name    = await getname();
        if(!name)return;
        
        var {code}    = await exec(`docker run -di -p :22 --name ${name} ${image_name}`);
        if(code)return console.log('error');
        
        var port    = await getport(name);
        console.log(`*** launch : ${name}:${port}`);

        
        await load_terminal();
        var npx       = `npx -p ssh2 electron -y terminal.js title=${name} port=${port} username=${username} password=${password}`;
        var {code}    = await exec(npx);
        if(code)return console.log('error');


        if(remove){
              remove_container(name);
        }
        
        
})();



        async function getname(){
          
              do{
                    var name      = get();
                    var result    = await chk(name);
                    if(result===false){
                          return false;
                    }
                    
              }while(result!==true);
              
              return name;
                    
                    
              function get(){
                
                    var col       = ['red','blue','pink','aqua','gold','gray','lime','navy'];
                    var flower    = ['rose','lily','iris','fern','dahlia','tulip','pansy','basil','sage','mint'];
                    var rnd       = arr=>arr[Math.floor(Math.random()*arr.length)];
                    var name      = `${image_name}---${rnd(col)}-${rnd(flower)}`;
                    return name;
                    
              }//get
        
              async function chk(name){
                
                    var {code,stdout,stderr}    = await exec('docker ps -f name=terminal');
                    if(code){
                          console.log('error');
                          return false;
                    }
                    if(stdout.indexOf(name)!=-1){
                          return 'found';
                    }
                    return true;
                    
              }//chk
                    
        }//getname
        
        async function getport(name){
          
              var {code,stdout,stderr}    = await exec(`docker port ${name}`);
              if(code)return console.log('error');
              var i       = stdout.indexOf(':');
              var port    = stdout.slice(i+1,-1);
              return port;
              
        }//getport
        
        function exec(cmd){
          
              var resolve,promise=new Promise(res=>resolve=res);
              var args    = cmd.split(' ');
              var cmd     = args.splice(0,1)[0];
              //var cmd     = 'powershell.exe';
              var child   = cp.spawn(cmd,args,{shell:true});
              var stdout='',stderr='';
              child.stdout.on('data',data=>(stdout+=data,console.log(data.toString())));
              child.stderr.on('data',data=>(stderr+=data,console.log(data.toString())));
              child.on('exit',code=>(console.log('code:',code),resolve({code,stdout,stderr})));
              return promise;
              
        }//exec
        
        async function load_terminal(){
          
              if(fs.existsSync('terminal.js'))return;
              var token   = '';
              var owner   = 'javascript-2020',repo='electron',path='terminal/terminal.js';
              var url     = `https://api.github.com/repos/${owner}/${repo}/contents/${path}`;
              var opts    = {headers:{accept:'application/vnd.github.raw+json'}};
              token && (opts.headers.authorization=`Bearer ${token}`);
              var txt     = await fetch(url,opts).then(res=>res.text());
              fs.writeFileSync('terminal.js',txt);
              
        }//exists

        async function remove_container(name){
        
              var {code,stdout,stderr}   = await exec(`docker rm -f ${name}`);
              if(code)return console.log('error');
              
        }//remove
        
        function cmdline(){
          
              image_name    = arg('image',image_name);
              
              function arg(name,def){return process.argv.reduce((acc,s)=>(s.startsWith(`${name}=`) && s.slice(name.length+1)) || acc,def)}
              
        }//cmdline
          
        
