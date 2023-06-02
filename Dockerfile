#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["deployment-app.csproj", "."]
RUN dotnet restore "./deployment-app.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "deployment-app.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "deployment-app.csproj" --self-contained true -r linux-x64 -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "deployment-app.dll"]