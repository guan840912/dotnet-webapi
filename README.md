# dotnet source to code 
首先  clone git 專案 

    $ git clone https://github.com/guan840912/dotnet-webapi.git
![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564042338854_image.png)


on master 會有 dockerfile 和 webapilab1 資料夾 

    #dockerfile 
    ===========================================================================
    FROM mcr.microsoft.com/dotnet/core/sdk:latest
    
    COPY ./webapilab1 /app/
    
    WORKDIR /app/bin/Debug/netcoreapp2.2
    
    CMD [ "sh", "-c", "dotnet webapilab1.dll" ]
    ===========================================================================
    

主要去從docker hub pull dotnet image 

![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564041851218_mrc_dotnet_images_sdk.PNG)


複製與dockerfile同一格資料夾下的 webapilab1 內的檔案or 資料夾 複製到 image 內的 /app/ 裡面
給與container 啟動後的工作資料夾
執行 `dotnet webapilab1.dll`

故clone 專案下來後 (環境要有 git 和 docker)


    #進入專案資料夾
    $ cd dotnet-webapi/
![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564042373997_image.png)

    #build docker image and tag it , . 是指當下資料夾的dockerfile
    $ docker build -t dotnetwebapi:0.1 .
![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564042393666_image.png)

    #docker images 顯示所有的images名稱為dotnetwebapi
    $ docker image ls -a dotnetwebapi
![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564042852926_image.png)

    #執行 docker run 指令 --name 給container name ,--rm container stop 就刪除 ,dotnetwebapi:0.1 image name  
    $ docker run --name dotwebapi -p 8000:80 --rm dotnetwebapi:0.1
    
    #執行後前端的terminal 會被吃掉 (如果不想被吃掉，可以在docker run 時 run 參數的後面加上 -d 參數<在背景執行>)像下面:
    $ docker run -d --name dotwebapi -p 8000:80 --rm dotnetwebapi:0.1
    
![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564043000764_image.png)

    #現在我們可以訪問我們docker host 的 ip 的 8000 port 
                           <port><call api?><id_var>
    http://<docker host ip>:8000/api/values/5555
    or (on docker host terminal)
    $ curl -s http://localhost:8000/api/values/555556 ; echo ""
                                              #<變數> <; echo 只是為了排版好看>
![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564043345438_image.png)

![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564043535405_image.png)

    #如果terminal 畫面沒有終止，將可以看到訪問logs
![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564043765012_image.png)

    #如果想終止，只需開啟另一個 terminal stop container
    $ docker container stop dotwebapi
    
    #查看正在執行的container 
    $ docker container ls 
![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564044095264_image.png)

![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564044039171_image.png)

![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564044228574_image.png)

----------
## 創建一個 source to image dockerfile
    #在擁有dockerfile 資料夾下執行，build image 指令。
    $ docker build -t stimage:0.1 .

**dockerfile**

    FROM microsoft/dotnet:2.1-sdk AS build
    WORKDIR /app
    
    RUN dotnet new webapi -n webapilab1 -o /app
    
    #will running dotnet restore on /app/webapilab1.csproj ...
    #and build bin/ in /app/
    RUN dotnet build
    
    #Publish the application with the specified project file
    RUN dotnet publish /app/webapilab1.csproj -c Release -o /app/out
    
    FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
    WORKDIR /app
    COPY --from=build /app/out ./
    ENTRYPOINT ["dotnet", "webapilab1.dll"]

透過擁有編譯環境的 **microsoft/dotnet:2.1-sdk** image 來編譯 source ，
，在 `docker build -t stimage:0.1 .` 時，docker host 會啟動一個基底為**microsoft/dotnet:2.1-sdk** image 的 container (以下統稱 **C1** )，一開始的工作目錄為 **C1** 內根目錄底下的 **/app** 資料夾，執行
`dotnet new webapi -n webapilab1 -o /app` 指令，指令的內容主要是說將創建一個wenapi 專案到，**C1** 根目錄底下的 **/app** 資料夾中，接著執行指令`**dotnet build**`，主要是安裝相依性套件道專案中，
接著執行`dotnet publish /app/webapilab1.csproj -c Release -o /app/out` 指令，將應用程式與相依性套件封裝至 **/app/out** 資料夾中，不使用 `-c` 參數的話，定義組態預值設為 `Debug` 。

接著啟動另一個 image 為 **microsoft/dotnet:2.1-aspnetcore-runtime 的** container (以下統稱 **C2** )進行 runtime 環境封裝，**C2** 一開始的工作環境為根目錄下的 **/app** 資料夾，接著就是 `docker engine 17.05`版後的 新追加的功能， --form=<前一個 **C1** 環境>，可以從前一個編譯環境中將編譯好的應用程式及相依性套件封裝的資料夾，複製到 **C2** runtime 環境中，`COPY --from=build /app/out ./` 複製 **C1**
/app/out/ 資料夾複製到 **C2  /app/** 資料夾下 ， 並將 runtime 的 entrypoint (指定容器啟動首要執行的程序及參數)設為 `ENTRYPOINT ["dotnet", "webapilab1.dll"]`  。


    #out put from docker build -t stimage:0.1 .
    Sending build context to Docker daemon  2.048kB
    Step 1/9 : FROM microsoft/dotnet:2.1-sdk AS build
     ---> d3fad9b1ee71
    Step 2/9 : WORKDIR /app
     ---> Running in b39c1e8221c9
    Removing intermediate container b39c1e8221c9
     ---> 4ab2e8d9ae3a
    Step 3/9 : RUN dotnet new webapi -n webapilab1 -o /app
     ---> Running in b55b549cc352
    Getting ready...
    The template "ASP.NET Core Web API" was created successfully.
    
    Processing post-creation actions...
    Running 'dotnet restore' on /app/webapilab1.csproj...
      Restore completed in 806.22 ms for /app/webapilab1.csproj.
    
    Restore succeeded.
    
    Removing intermediate container b55b549cc352
     ---> 11b4cca25565
    Step 4/9 : RUN dotnet build
     ---> Running in 38009a0a30f3
    Microsoft (R) Build Engine version 16.2.32702+c4012a063 for .NET Core
    Copyright (C) Microsoft Corporation. All rights reserved.
    
      Restore completed in 40.56 ms for /app/webapilab1.csproj.
      webapilab1 -> /app/bin/Debug/netcoreapp2.1/webapilab1.dll
    
    Build succeeded.
        0 Warning(s)
        0 Error(s)
    
    Time Elapsed 00:00:05.05
    Removing intermediate container 38009a0a30f3
     ---> 0633d5dfdc26
    Step 5/9 : RUN dotnet publish /app/webapilab1.csproj -c Release -o /app/out
     ---> Running in 544b09a2e032
    Microsoft (R) Build Engine version 16.2.32702+c4012a063 for .NET Core
    Copyright (C) Microsoft Corporation. All rights reserved.
    
      Restore completed in 43.21 ms for /app/webapilab1.csproj.
      webapilab1 -> /app/bin/Release/netcoreapp2.1/webapilab1.dll
      webapilab1 -> /app/out/
    Removing intermediate container 544b09a2e032
     ---> 703efda79a9d
    Step 6/9 : FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
     ---> 1b31cbe6a2cd
    Step 7/9 : WORKDIR /app
     ---> Running in cb5349f618df
    Removing intermediate container cb5349f618df
     ---> c3f58902d982
    Step 8/9 : COPY --from=build /app/out ./
     ---> f5fb59d272d2
    Step 9/9 : ENTRYPOINT ["dotnet", "webapilab1.dll"]
     ---> Running in c18cdcb06ef8
    Removing intermediate container c18cdcb06ef8
     ---> 92eed87072b8
    Successfully built 92eed87072b8
    Successfully tagged stimage:0.1
    
    #接著就可以查詢一下image。
    $ docker image ls -a stimage:0.1
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    stimage             0.1                 92eed87072b8        14 seconds ago      253MB
    
    #執行容器，將docker host 的 8081 port 串聯到 container 內的 80 port 上。
    $ docker run -p 8081:80 -d stimage:0.1
    
    #查詢容器狀態
    $ docker container ls
    CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                                                    
    ae2e16aa4b92        stimage:0.1                "dotnet webapilab1.d…"   6 seconds ago       Up 5 seconds        0.0.0.0:8081->80/tcp                                     
    
    #查看容器logs 
    $ docker container logs ae2e16aa4b92
    warn: Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager[35]
          No XML encryptor configured. Key {0d570cc1-95fb-4dc6-81a9-60460a5eb198} may be persisted to storage in unencrypted form.
    Hosting environment: Production
    Content root path: /app
    Now listening on: http://[::]:80
    Application started. Press Ctrl+C to shut down.

訪問 api ; `http://docker_host_ip:8081/api/values/555555`

![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564114948915_image.png)

----------
## 嘗試更新source code 
    $ ls webapilab1/
    app                           obj         webapilab1.csproj
    appsettings.Development.json  Program.cs  wwwroot
    appsettings.json              Properties
    Controllers                   Startup.cs
    
    #將本地端的source code 掛載進container 內。
    $ docker run -v /home/guan/dotnettest/webapilab1:/app -p 5000:80 -it  microsoft/dotnet:2.1-sdk  bash
    
    root@297d0e923bd3:/# ls 
    app  boot  etc   lib    media  opt   root  sbin  sys  usr
    bin  dev   home  lib64  mnt    proc  run   srv   tmp  var
    root@297d0e923bd3:/# cd app/
    root@297d0e923bd3:/app# ls
    Controllers  app                           webapilab1.csproj
    Program.cs   appsettings.Development.json  wwwroot
    Properties   appsettings.json
    Startup.cs   obj
    
    #編譯dockerhost 端的 source code (編譯docker host端的source code 等於編譯container 內的source code ) ，   藍標為編譯後的部分。
    $ vi Controllers/ValuesController.cs 
    ==========================================================================
    
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    
    namespace webapilab1.Controllers
    {
        [Route("api/[controller]")]
        [ApiController]
        public class ValuesController : ControllerBase
        {
            // GET api/values
            [HttpGet]
            public ActionResult<IEnumerable<string>> Get()
            {
                return new string[] { "value1", "value2" };
            }
    
            // GET api/values/5
            [HttpGet("{id}")]
            public ActionResult<string> Get(int id)
            {
                return "value=" + id;
            }
    
            // POST api/values
            [HttpPost]
            public void Post([FromBody] string value)
            {
            }
    
            // PUT api/values/5
            [HttpPut("{id}")]
            public void Put(int id, [FromBody] string value)
            {
            }
    
            // DELETE api/values/5
            [HttpDelete("{id}")]
            public void Delete(int id)
            {
            }
        }
    }
    ==========================================================================
    #編譯好後，在container 內進行build and publish  
    root@297d0e923bd3:/app# dotnet build
    Microsoft (R) Build Engine version 16.2.32702+c4012a063 for .NET Core
    Copyright (C) Microsoft Corporation. All rights reserved.
    
      Restore completed in 527.16 ms for /app/webapilab1.csproj.
      webapilab1 -> /app/bin/Debug/netcoreapp2.1/webapilab1.dll
    
    Build succeeded.
        0 Warning(s)
        0 Error(s)
    
    Time Elapsed 00:00:06.24
    
    root@297d0e923bd3:/app# dotnet publish /app/webapilab1.csproj -c Release -o /app/out
    Microsoft (R) Build Engine version 16.2.32702+c4012a063 for .NET Core
    Copyright (C) Microsoft Corporation. All rights reserved.
    
      Restore completed in 42.57 ms for /app/webapilab1.csproj.
      webapilab1 -> /app/bin/Release/netcoreapp2.1/webapilab1.dll
      webapilab1 -> /app/out/
    #可以out/ 資料夾已出現 
    root@297d0e923bd3:/app# ls
    Controllers  app                           obj
    Program.cs   appsettings.Development.json  out
    Properties   appsettings.json              webapilab1.csproj
    Startup.cs   bin                           wwwroot
    
    #進入 out/ 資料夾內，執行 dotnet webapilab1.dll 進行測試
    root@297d0e923bd3:/app# cd out/
    root@297d0e923bd3:/app/out# dotnet webapilab1.dll
    warn: Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager[35]
          No XML encryptor configured. Key {53627177-b5c5-40d5-bb69-f6abf3c4a908} may be persisted to storage in unencrypted form.
    Hosting environment: Production
    Content root path: /app/out
    Now listening on: http://[::]:80
    Application started. Press Ctrl+C to shut down.
    warn: Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionMiddleware[3]
    
    訪問 docker host 的 5000 port ， 因為 docker host 的 5000 port 與 container 內的 80 已進行串接。 可以看出剛剛編譯後的效果以成功產出。
![編譯 前](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564114948915_image.png)

![編譯 後](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564116502683_image.png)


修改 source code to image dockerfile 

    #進入本地端的專案資料夾，
    $ cd /home/guan/dotnettest/webapilab1
    
    $ vim dockerfile 
    ================================================================
    FROM microsoft/dotnet:2.1-sdk AS build
    WORKDIR /app
    
    COPY ./ /app
    
    #will running dotnet restore on /app/webapilab1.csproj ...
    #and build bin/ in /app/
    RUN dotnet build
    
    #Publish the application with the specified project file
    RUN dotnet publish /app/webapilab1.csproj -c Release -o /app/out
    
    FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
    WORKDIR /app
    COPY --from=build /app/out ./
    ENTRYPOINT ["dotnet", "webapilab1.dll"]
    ================================================================
    #build image stimage:0.2 
    $ docker build -t stimage:0.2 .
    Sending build context to Docker daemon  2.353MB
    Step 1/9 : FROM microsoft/dotnet:2.1-sdk AS build
     ---> d3fad9b1ee71
    Step 2/9 : WORKDIR /app
     ---> Using cache
     ---> 4ab2e8d9ae3a
    Step 3/9 : COPY ./ /app
     ---> 4a9a96646749
    Step 4/9 : RUN dotnet build
     ---> Running in b5adfca717a9
    Microsoft (R) Build Engine version 16.2.32702+c4012a063 for .NET Core
    Copyright (C) Microsoft Corporation. All rights reserved.
    
      Restore completed in 38.35 ms for /app/webapilab1.csproj.
      webapilab1 -> /app/bin/Debug/netcoreapp2.1/webapilab1.dll
    
    Build succeeded.
        0 Warning(s)
        0 Error(s)
    
    Time Elapsed 00:00:02.41
    Removing intermediate container b5adfca717a9
     ---> 5a14463233b6
    Step 5/9 : RUN dotnet publish /app/webapilab1.csproj -c Release -o /app/out
     ---> Running in ce9bd739e856
    Microsoft (R) Build Engine version 16.2.32702+c4012a063 for .NET Core
    Copyright (C) Microsoft Corporation. All rights reserved.
    
      Restore completed in 39.87 ms for /app/webapilab1.csproj.
      webapilab1 -> /app/bin/Release/netcoreapp2.1/webapilab1.dll
      webapilab1 -> /app/out/
    Removing intermediate container ce9bd739e856
     ---> 577d32e673cb
    Step 6/9 : FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
     ---> 1b31cbe6a2cd
    Step 7/9 : WORKDIR /app
     ---> Using cache
     ---> c3f58902d982
    Step 8/9 : COPY --from=build /app/out ./
     ---> 58f603d736b1
    Step 9/9 : ENTRYPOINT ["dotnet", "webapilab1.dll"]
     ---> Running in 41fbaff60e51
    Removing intermediate container 41fbaff60e51
     ---> ee3870cb9cfb
    Successfully built ee3870cb9cfb
    Successfully tagged stimage:0.2
    
    #執行container 
    $ docker run -p 5001:80 --name stimage_2 -d  stimage:0.2
    #查看container
    $ docker container ls
    CONTAINER ID        IMAGE                      COMMAND                  CREATED             STATUS              PORTS                  NAMES
    80422ef34674        stimage:0.2                "dotnet webapilab1.d…"   11 seconds ago      Up 10 seconds       0.0.0.0:5001->80/tcp   stimage_2
    
    #訪問 http://docker_host_ip:5001/api/values/123 ; 執行成功。
![](https://paper-attachments.dropbox.com/s_1F9B26AAFC0641BBEB5823E0CC143EBA71DB1E5B970C880C2126C74B0DE507FD_1564117603244_image.png)

    #查看已build的兩個 image，可以看到有兩版0.1 及 0.2 版。
    $ docker image ls -a stimage
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    stimage             0.2                 ee3870cb9cfb        6 minutes ago       254MB
    stimage             0.1                 92eed87072b8        2 hours ago         253MB
    



#                            MISSION CLOSE

