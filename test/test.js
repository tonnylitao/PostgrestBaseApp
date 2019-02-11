import ava from "ava";
import superagent from "superagent";
import yml from "yaml";
import path from "path";
import fs from "fs";

const host = "nginx_host/api";

function valueInPath(target, keypath) {
  return keypath.split(".").reduce((result, key) => {
    return result[key];
  }, target);
}

//TODO: find all yml files
const files = ["me.yml", "users.yml"];
files.forEach(name => {
  const config = yml.parse(fs.readFileSync(`./${name}`, "utf8"));

  config.tests.forEach(test => {
    const method = config.method || test.method;
    const api = config.api || test.api;

    ava(`${name} ${test.name}`, async t => {
      let req = superagent(method, host + api);

      //header
      if (test.set) {
        req = req.set(test.set);
      }
      //query
      if (test.query) {
        req = req.query(test.query);
      }
      if (test.send) {
        req = req.send(test.send);
      }

      let res;
      try {
        res = await req;
      } catch ({ response }) {
        res = response;
      }

      Object.keys(test.res).forEach(keypath => {
        try {
          t.is(valueInPath(res, keypath), test.res[keypath]);
        } catch (e) {
          console.log(keypath, res.body);
          t.fail();
        }
      });
    });
  });
});
