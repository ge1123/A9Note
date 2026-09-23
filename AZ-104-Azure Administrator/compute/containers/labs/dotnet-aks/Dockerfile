FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY src/LabApi/LabApi.csproj LabApi/
RUN dotnet restore LabApi/LabApi.csproj
COPY src/LabApi/ LabApi/
RUN dotnet publish LabApi/LabApi.csproj -c Release -o /out --no-restore /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /out .
ENV ASPNETCORE_HTTP_PORTS=8080
USER $APP_UID
EXPOSE 8080
ENTRYPOINT ["dotnet", "LabApi.dll"]
