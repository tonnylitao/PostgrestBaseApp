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

const name = path.basename(__filename).split(".test.js")[0];
const dir = path.join(__dirname, name);

fs.readdirSync(dir).forEach(function(file) {
  const config = yml.parse(fs.readFileSync(`./${name}/${file}`, "utf8"));

  config.tests.forEach(test => {
    const method = test.method || config.method;
    const api = test.api || config.api;

    //TODO order
    ava(`${file} ${test.name}`, async t => {
      let req = superagent(method, host + api);

      //set, query, send
      Object.keys(test.superagent).forEach(item => {
        req = req[item](test.superagent[item]);
      });

      let res;
      try {
        res = await req;
      } catch ({ response }) {
        res = response;
      }

      Object.keys(test.t).forEach(func => {
        const asserts = test.t[func] || {};

        Object.keys(asserts).forEach(keypath => {
          try {
            //is, not, deepEqual
            t[func](valueInPath(res, keypath), asserts[keypath]);
          } catch (e) {
            console.log(func, keypath, res.body);
            t.fail();
          }
        });
      });
    });
  });
});
