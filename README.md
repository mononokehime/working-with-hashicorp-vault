# Hashicorp Vault Testing
Creating policies with terraform is fairly straightforward. This project is about testing the outputs and checking
policies work as expected.

# Start the Vault Server in Development Mode
From the root directory
```bash
docker-compose -f ./docker/docker-compose.yml up -d
docker-compose -f ./docker/docker-compose.yml down
```
Export the root token 
```bash
export VAULT_DEV_ROOT_TOKEN_ID=$(docker logs $(docker ps -aqf "name=vault") 2>&1 | grep Token | awk '{print $3}')
export VAULT_ADDR='http://127.0.0.1:8200'
```
