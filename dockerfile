FROM mcr.microsoft.com/dotnet/core/sdk:latest

COPY ./webapilab1 /app/

WORKDIR /app/bin/Debug/netcoreapp2.2

CMD [ "sh", "-c", "dotnet webapilab1.dll" ]
