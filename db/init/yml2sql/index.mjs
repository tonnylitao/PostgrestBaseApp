import fs from "fs";
import rimraf from "rimraf";

import createsql from "./create-sql";
import createsample from "./create-sample";

const dir = "./build";
rimraf(dir, {}, () => {
  fs.mkdirSync(dir);

  createsql("./build/sql");
  createsample("./build/sample");
});

console.log("create sql and sample success");
