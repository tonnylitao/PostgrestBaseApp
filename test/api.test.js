import ava from "ava";
import superagent from "superagent";
import yml from "yaml";
import path from "path";
import fs from "fs";
import ejs from "ejs";
import faker from "faker";

const host = "nginx_host/api";

function valueInPath(target, keypath) {
  return keypath.split(".").reduce((result, key) => {
    return result[key];
  }, target);
}

const name = path.basename(__filename).split(".test.js")[0];
const dir = path.join(__dirname, name);

const globleText = fs.readFileSync(`./config.yml`, "utf8");
const globleNewText = ejs.render(globleText, { faker });
const globle = yml.parse(globleNewText);

fs.readdirSync(dir).forEach(function(file) {
  const text = fs.readFileSync(`./${name}/${file}`, "utf8");

  const config = yml.parse(ejs.render(text, globle));

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
            console.log(func, keypath);
            t.fail();
          }
        });
      });
    });
  });
});
