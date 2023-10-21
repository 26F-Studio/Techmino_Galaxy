local scene={}

function connect()
    love.thread.newThread([[
        local socket=require("socket")
        local server=assert(socket.bind("*", 10026))
        local ip,port=server:getsockname()
        print("Please telnet to "..ip.." on port "..port)
        print("After connecting, you have 10s to enter a line to be echoed")
        while 1 do
            local client=server:accept()
            client:settimeout(10)
            local line,err=client:receive()
            if not err then
                print("R: "..line)
                client:send(line)
            end
            client:close()
        end
    ]]):start()
end

function send()
    love.thread.newThread([[
        local host=...
        local port=10026
        local socket=require("socket")
        local tcp=assert(socket.tcp())
        tcp:connect(host, port);
        tcp:send("hello world\n");
        
        while true do
            local s,status,partial=tcp:receive()
            print(s or partial)
            love.thread.getChannel("test"):push(s or partial)
            if status=="closed" then break end
        end
        tcp:close()
    ]]):start(scene.widgetList.hostInputBox:getText())
end

function scene.update()
    if love.thread.getChannel("test"):peek() then
        MSG.new("info", love.thread.getChannel("test"):pop())
    end
end

scene.widgetList={
    {name='hostInputBox',  type='inputBox',x=400, y=600,w=600,h=60,lineWidth=4,cornerR=0,fontSize=20},
    {name='receiveTextBox',type='textBox', x=400, y=700,w=600,h=60,lineWidth=4,cornerR=0,fontSize=20},
    {name='connectButton', type='button',  x=1200,y=530,w=200,h=60,lineWidth=4,cornerR=0,fontSize=30,text='Connect',code=connect},
    {name='sendButton',    type='button',  x=1200,y=630,w=200,h=60,lineWidth=4,cornerR=0,fontSize=30,text='Send',   code=send},
}
return scene
