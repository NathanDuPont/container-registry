#!/bin/bash
# Print out executed commands
set -x

cd ../ || exit

echo "Removing existing registry container if exists"
container_id="$(docker container ls -a -q -f "name=container-registry")"

# If the container exists, kill it (in case it's running) then
# remove it to allow a new container to be created
[[ $container_id != "" ]] && docker kill "$container_id" ; docker container rm "$container_id"

# TODO only run with certs if there are certs present

# Run a new registry container. Guide from https://docs.docker.com/registry/deploying/
echo "Running new container registry"
docker run -d \
    --restart=always \
    --name container-registry \
    -v "$(pwd)"/certs:/certs \
    -v "$(pwd)"/registry:/var/lib/registry \
    -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/container-registry.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/container-registry.key \
    -p 443:443 registry:latest
