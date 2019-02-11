import test from "ava";
import supertest from "supertest";
import yml from "yaml";
import path from "path";
import fs from "fs";

const host = "nginx_host";

const name = path.basename(__filename).split(".test.js")[0];
const config = yml.parse(fs.readFileSync(`./${name}.yml`, "utf8"));

config.tests.forEach(item => {
  test(item.name, async t => {
    const api = config.api || item.api;

    const res = await supertest(host + "/api").get(api);

    Object.keys(item.ava).forEach(keypath => {
      t.is(valueInPath(item.ava, keypath), item.ava[keypath]);
    });

    t.pass();
  });
});

function valueInPath(target, keypath) {
  return keypath.split(".").reduce((result, key) => {
    return result[key];
  }, target);
}
