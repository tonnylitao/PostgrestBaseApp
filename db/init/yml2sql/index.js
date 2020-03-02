const fs = require("fs");
const rimraf = require('rimraf')

const createsql = require("./create-sql");
const createsample = require("./create-sample");

const dir = "./build";
rimraf(dir, {}, () => {
  fs.mkdirSync(dir);

  createsql("./build/sql");
  createsample("./build/sample");
});

console.log("create sql and sample success");
