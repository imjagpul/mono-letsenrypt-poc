FROM mono:6.12.0.122

RUN apt-get update && apt-get -y install ca-certificates && apt-get clean  && rm -rf /var/lib/apt/lists/*

# workaround of a broken chain certificate validator that is used in BoringSSL that Mono includes
# without it SSL connections to endpoints secured with any Let's encrypt certificate would fail
#
# if the following issue is ever fixed, it will probably be possible to remove this:
# https://github.com/mono/mono/issues/21233
#
# blacklist the X3 certificate:
RUN sed -i 's#mozilla/DST_Root_CA_X3.crt#!mozilla/DST_Root_CA_X3.crt#' /etc/ca-certificates.conf && update-ca-certificates

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
