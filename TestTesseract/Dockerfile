FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /App

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:7.0
RUN apt update
RUN apt install -y libtesseract-dev
RUN apt install -y tesseract-ocr
RUN apt install -y libc6-dev
WORKDIR /App
COPY --from=build-env /App/out .
RUN ln -s /usr/lib/x86_64-linux-gnu/liblept.so.5 ./x64/libleptonica-1.82.0.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libtesseract.so.4 ./x64/libtesseract50.so
ENTRYPOINT ["dotnet", "TestTesseract.dll"]
