# Hashicorp Vault Testing
Creating policies with terraform is fairly straightforward. This project is about testing the outputs and checking
policies work as expected.

## Project Contents
[README](README.md) The project readme file
[docker](docker) Docker related files for running vault
[terraform](terraform) Terraform files for populating roles and permissions in Vault

## Start the Vault Server in Development Mode
From the root directory
```sh
docker-compose -f ./docker/docker-compose.yml up -d
docker-compose -f ./docker/docker-compose.yml down
```
Export the root token 
```sh
export VAULT_DEV_ROOT_TOKEN_ID=$(docker logs $(docker ps -aqf "name=vault") 2>&1 | grep Token | awk '{print $3}')
export VAULT_TOKEN=$VAULT_DEV_ROOT_TOKEN_ID
export VAULT_ADDR='http://127.0.0.1:8200'
```

## Run terraform to create policies
```sh
module=$1
TERRAFORM_IMAGE=hashicorp/terraform:0.11.14
cd $module
TERRAFORM_CMD="docker run -ti --rm --name test --network=docker_vault-nw -w /app -v `pwd`:/app -e VAULT_ADDR=${VAULT_ADDR} -e VAULT_TOKEN=${VAULT_TOKEN} ${TERRAFORM_IMAGE}"
${TERRAFORM_CMD} init
${TERRAFORM_CMD} plan
${TERRAFORM_CMD} apply

 TERRAFORM_CMD="docker run -ti --rm -w /app -v `pwd`:/app ${TERRAFORM_IMAGE}"

## this is testing vault commands with a vault image
VAULT_IMAGE=vault:latest
docker run -it --rm --name test --network=docker_vault-nw -e VAULT_ADDR=${VAULT_ADDR} -e VAULT_TOKEN=${VAULT_TOKEN} ${VAULT_IMAGE} vault auth list

```



