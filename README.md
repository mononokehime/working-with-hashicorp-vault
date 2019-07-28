# Working with Hashicorp Vault
This project is all about setting up and connecting to Hashicorp Vault in development mode. It has only been tested on MacOS Mojave.

## User Setup
In this project we are going to create the following types of user

| Role Type  | Permissions  | Description  |
|---|---|---|
| root |full control|Only use to create other roles, and set up main authentication type, creates vault admin users|
|`${application-name}`-ro|Read only role for application|Allows an application to login and read secrets from te specified path|

## Start the Vault Server in Development Mode
From the root directory type
```sh
docker-compose -f ./docker/docker-compose.yml up -d
docker-compose -f ./docker/docker-compose.yml down
```
This will start Vault in development mode and create a `docker/vault` directory.

In another terminal window, export the root token so that we can login to Vault
```sh
VAULT_TOKEN=$(docker logs $(docker ps -aqf "name=vault") 2>&1 | grep Token | awk '{print $3}')
# Use vault because we are using docker networking
VAULT_ADDR='http://vault:8200'
```

## Run terraform to create policies
```sh
cd application
TERRAFORM_IMAGE=hashicorp/terraform:0.11.14
# create a command alias
TERRAFORM_CMD="docker run -ti --rm --name test --network=docker_vault-nw -w /app -v `pwd`:/app -e VAULT_ADDR=${VAULT_ADDR} -e VAULT_TOKEN=${VAULT_TOKEN} ${TERRAFORM_IMAGE}"

${TERRAFORM_CMD} init
${TERRAFORM_CMD} plan -out=app-plan
VAULT_TOKEN=$(docker logs $(docker ps -aqf "name=vault") 2>&1 | grep Token | awk '{print $3}') ${TERRAFORM_CMD} apply "app-plan"

```
### What will the command create?
A read only approle user will be created with the following details
Mount path: `applications/${var.application_name}/approle`
Role name: `${var.application_name}-ro`
Role access rights: 
            `applications/${var.application_name}/approle/login` create for login
            `applications/${var.application_name}/*` read for secrets
Policy name: `${var.application_name}-application-ro`

## Validate the paths
You can validate login in the following way. To do this, you will need permissions that grant acces to the path. Root, for example.
```sh
# get the vault container id
container_id=$(docker ps --filter "name=vault" --filter "status=running" --format {{.ID}})
# Login to the vault container
docker exec -it $container_id sh
# set the app name and app role
APP_NAME=test
APP_ROLE=test-ro
# get the role id
ROLE_ID=$(vault read auth/applications/${APP_NAME}/approle/role/${APP_ROLE}/role-id | head -3 | tail -1 | awk '{print $2}')
# get the role's secrt id
SECRET_ID=$(vault write -f auth/applications/${APP_NAME}/approle/role/${APP_ROLE}/secret-id | head -3 | tail -1 | awk '{print $2}')
# get the token 
TOKEN_ID=$(vault write auth/applications/${APP_NAME}/approle/login role_id=${ROLE_ID} secret_id=${SECRET_ID} | head -3 | tail -1 | awk '{print $2}')
# now try to login
vault login ${TOKEN_ID}

```

## TODO
- Setting up a production-like server
- Running inside kubernetes
- Improve user hierarchy
- Show different methods of authentication
- add more user types
- add spring boot integration
- make readme in correct directories

## Project Contents
[README](README.md) The project readme file
[docker](docker) Docker related files for running vault
[terraform](terraform) Terraform files for populating roles and permissions in Vault
