# Container Certs

Mount this folder as a volume linked to `/certs` within the docker container. This will allow for the registry to use SSL, while persisting the certs locally when needing to recreate the docker image for updates and/or fixes.