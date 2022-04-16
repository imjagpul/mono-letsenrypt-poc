# mono-letsenrypt-poc
A proof-of-concept of an issue in Mono with Let's encrypt certificates.

Just check out and run (with Docker Desktop or similiar installed):

`docker build -t mono-letsenrypt-poc` 
`docker run mono-letsenrypt-poc`

Connecting to any site with Let's encrypt certificate fails from Mono within the docker image, but works from .NET framework as run from Visual Studio.
