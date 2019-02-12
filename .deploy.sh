#!/bin/bash

#exit when any error
set -e

APP_NAME='app'
GIT_BRANCH=$(git symbolic-ref -q HEAD)

echo "target git branch: $GIT_BRANCH"

echo "start to npm install and build......"

env=''
postgrest_app_host=''
if [ $GIT_BRANCH == "refs/heads/release" ]; then
  env="staging"
  postgrest_app_host=''

elif [ $GIT_BRANCH == "refs/heads/master" ]; then
  env="prod"
  postgrest_app_host=''
else
  exit 0
fi

sed "s/postgrest_app_host/$postgrest_app_host/g" nginx-react/nginx-template.conf > nginx-react/nginx.conf

cd ./db/init/yml2sql && yarn install && npm run build && cd ../../../

cd ./nginx-react/react-app && yarn install && npm run build:$env && cd ../../
cd ./nginx-react/react-app-admin && yarn install && npm run build:$env && cd ../../


# push to remote server

docker-compose up --build --force-recreate -d

exit 0
