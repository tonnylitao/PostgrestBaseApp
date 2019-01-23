module.exports = {

  apps : [
    {
      name      : 'node-app',
      script    : 'index.js',
      env: {
        COMMON_VARIABLE: 'true'
      },
      env_production : {
        NODE_ENV: 'production'
      }
    }
  ]
};
