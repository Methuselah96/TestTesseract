FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /App

# Copy everything
COPY ./Tesseract ./Tesseract
COPY ./TestTesseract ./TestTesseract
# Restore as distinct layers
RUN dotnet restore ./TestTesseract/TestTesseract.csproj
# Build and publish a release
RUN dotnet publish  ./TestTesseract/TestTesseract.csproj -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0
RUN apt update
RUN apt install -y libtesseract-dev
RUN apt install -y tesseract-ocr
RUN apt install -y libc6-dev
WORKDIR /App
COPY --from=build-env /App/out .
RUN ln -s /usr/lib/x86_64-linux-gnu/liblept.so.5 ./x64/libleptonica-1.82.0.so
RUN ln -s /usr/lib/x86_64-linux-gnu/libtesseract.so.5 ./x64/libtesseract50.so
ENTRYPOINT ["dotnet", "TestTesseract.dll"]
