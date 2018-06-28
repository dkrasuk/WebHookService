FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 64074
EXPOSE 44387

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY WebHookService/WebHookService.csproj WebHookService/
RUN dotnet restore WebHookService/WebHookService.csproj
COPY . .
WORKDIR /src/WebHookService
RUN dotnet build WebHookService.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish WebHookService.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WebHookService.dll"]
