import fs from "fs";
import rimraf from "rimraf";

import builder from "./create-api";

const dir = "./build";
rimraf(dir, {}, () => {
  fs.mkdirSync(dir);

  builder("./build");

  console.log("create api success");
});
