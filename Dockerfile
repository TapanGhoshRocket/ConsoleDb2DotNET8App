#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base
USER app
WORKDIR /app

ENV LD_LIBRARY_PATH="/app/clidriver/lib/"
#RUN apt-get -y update && apt-get install -y libxml2

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["ConsoleDb2DotNET8App.csproj", "."]
RUN dotnet restore "./ConsoleDb2DotNET8App.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ConsoleDb2DotNET8App.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ConsoleDb2DotNET8App.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV PATH=$PATH:/app/clidriver/lib:/app/clidriver/adm
CMD tail -f /dev/null
