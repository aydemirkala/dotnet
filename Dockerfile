FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-dotnet-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build
WORKDIR /src
COPY ["myWebApp/myWebApp.csproj", "myWebApp/"]
RUN dotnet restore "myWebApp/myWebApp.csproj"
COPY . .
WORKDIR "/src/myWebApp"
RUN dotnet add package SkyAPM.Agent.AspNetCore \
    && export ASPNETCORE_HOSTINGSTARTUPASSEMBLIES=SkyAPM.Agent.AspNetCore \
    && export SKYWALKING__SERVICENAME=myWebApp \
    && dotnet tool install -g SkyAPM.DotNet.CLI \
    && export PATH="$PATH:/root/.dotnet/tools" \
    && dotnet skyapm config myWebApp skywalking-oap.test-integration-apisix.svc.cluster.local:11800

RUN dotnet build "myWebApp.csproj" -c Release -o /app/build
RUN dotnet pack /p:Version=1.2.0 -c Release --no-restore -o /app/build 
RUN dotnet nuget push /app/build/*.nupkg --source https://api.nuget.org/v3/index.json --api-key "NUGET_API_KEY"

FROM build AS publish
RUN dotnet publish "myWebApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
ENV ASPNETCORE_HOSTINGSTARTUPASSEMBLIES=SkyAPM.Agent.AspNetCore
ENV SKYWALKING__SERVICENAME=myWebApp
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "myWebApp.dll"]
