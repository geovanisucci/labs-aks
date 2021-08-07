  
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/labs.aks.service.host/labs.aks.service.host.csproj", "labs.aks.service.host/"]
RUN dotnet restore "labs.aks.service.host/labs.aks.service.host.csproj"
COPY ./src .
WORKDIR /src/labs.aks.service.host
RUN dotnet build "labs.aks.service.host.csproj" -c Release -o /app
FROM build AS publish
RUN dotnet publish "labs.aks.service.host.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "labs.aks.service.host.dll"]