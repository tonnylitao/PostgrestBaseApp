#!/bin/bash

#exit when any error
set -e

sed "/#remove_in_local_start/,/#remove_in_local_end/d" nginx-react/nginx-template.conf > nginx-react/nginx.conf

cd ./db/init/yml2sql && yarn install && npm run build && cd ../../../

cd ./nginx-react/react-app && yarn install && cd ../../
cd ./nginx-react/react-app-admin && yarn install && cd ../../

docker-compose -f docker-compose-local.yml down
docker-compose -f docker-compose-local.yml up --build --force-recreate

exit 0
