FROM mono:6.12.0.122

RUN apt-get update && apt-get -y install ca-certificates && apt-get clean  && rm -rf /var/lib/apt/lists/*
RUN update-ca-certificates

#sync system CAs to mono
RUN cert-sync /etc/ssl/certs/ca-certificates.crt

#update CAs to what is freshly downloaded from Mozilla
# RUN mozroots --import --sync
# RUN mozroots --import --sync --machine

# switch to legacy mono tls provider
# ENV MONO_TLS_PROVIDER legacy

ENV APP_PATH /app
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

COPY Program.cs $APP_PATH
COPY mono-letsenrypt-poc.csproj $APP_PATH
COPY mono-letsenrypt-poc.sln $APP_PATH
COPY Properties/AssemblyInfo.cs $APP_PATH/Properties/AssemblyInfo.cs
COPY App.config $APP_PATH

RUN mono --version

RUN msbuild mono-letsenrypt-poc.sln
CMD [ "mono", "bin/Debug/mono-letsenrypt-poc.exe" ]
