//  https://github.com/javascript-2020/stackoverflow/blob/main/term/term.js

        console.log('terminal.js');
        console.log(process.argv);
        
        var username    = arg('username','root'),
            password    = arg('password','node'),
            host        = arg('host','127.0.0.1'),
            port        = arg('port',2222),
            title       = arg('title','terminal');
            title       = `${title} - ${username}@${host}:${port}`;

        function arg(name,def){return process.argv.reduce((acc,s)=>(s.startsWith(`${name}=`) && s.slice(name.length+1)) || acc,def)}
        
        console.log(title);            
        console.log(username,password,host,port);
        
        var {app,BrowserWindow}  = require('electron');
        var webPreferences       = {nodeIntegration:true,contextIsolation:false};
        app.whenReady().then(()=>{
              var win   = new BrowserWindow({webPreferences});
              win.maximize();
              win.webContents.openDevTools();
              win.loadURL(`data:text/html;base64,${btoa(html)}`);
              
              
        });
        
        
        var html    = `
              <title>${title}</title>
              <link rel=stylesheet href='https://cdn.jsdelivr.net/npm/@xterm/xterm/css/xterm.min.css'>
              <style>
                    html { height:100% }
                    body { height:calc(100% - 16px) }
                    #terminal { height:100% }
              </style>
              
              <div id=terminal></div>
              
              <script type=module>
              
                    import xterm from 'https://cdn.jsdelivr.net/npm/@xterm/xterm@5.5.0/+esm';
                    import addonFit from 'https://cdn.jsdelivr.net/npm/@xterm/addon-fit/+esm';
                    
                    var {Client}    = require('ssh2');
                    var con         = new Client();
                    var stream;
                    
                    var term        = new xterm.Terminal();
                    var fitAddon    = new addonFit.FitAddon();
                    term.loadAddon(fitAddon);
                    term.open(terminal);
                    term.onKey(({key,domEvent:e})=>stream.write(key));
                    
                    con.on('ready',()=>{
                          fitAddon.fit();
                          term.focus();
                          con.shell((err,stream2)=>{
                                stream    = stream2;
                                stream.on('data',data=>term.write(data));
                          });
                    });
                    
                    con.connect({host:'${host}',port:${port},username:'${username}',password:'${password}',debug:console.log});
                    
              </script>
        `;

        
          
