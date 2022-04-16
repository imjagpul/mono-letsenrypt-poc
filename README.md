# mono-letsenrypt-poc
A demonstration of an issue in Mono with Let's encrypt certificates.

Just check out and run (with Docker Desktop or similiar installed):

```shell
docker build -t mono-letsencrypt-poc
docker run mono-letsencrypt-poc
```

Connecting to any site secured with Let's encrypt certificate fails from Mono within the docker image, but works from .NET framework when run from Visual Studio.
