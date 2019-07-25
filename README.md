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
## 所以如果當developer  開發

