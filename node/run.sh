#!/bin/sh

set -e

echo node $ENV

#TODO dbName dbUser dbPW
if [ "$ENV" == "development" ]; then
  pm2-dev ecosystem.config.js
fi

if [ "$ENV" == "production" ]; then
  pm2-runtime ecosystem.config.js
fi
