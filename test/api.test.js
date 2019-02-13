import ava from "ava";
import superagent from "superagent";
import yml from "yaml";
import path from "path";
import fs from "fs";
import ejs from "ejs";
import faker from "faker";

const env_host = process.env.env_host;
const host = `${env_host}/api`;

function valueInPath(target, keypath) {
  return keypath.split(".").reduce((result, key) => {
    return result[key];
  }, target);
}

const globle = {
  user: {
    Authorization:
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSIsInJvbGUiOiJhcHBfdXNlciJ9.at0C_NxdRzjTjY9Bdetx7BNhJIXnnH4C8FLLEg-9fEU"
  },

  admin: {
    Authorization:
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMiIsInJvbGUiOiJhcHBfYWRtaW4ifQ.kbehGj6z_VBoTce_v5h3xP5CYA2_CvxY1UlhEQlNxDw"
  },

  faker_random_words: faker.random.words()
};

const name = path.basename(__filename).split(".test.js")[0];
const dir = path.join(__dirname, name);

fs.readdirSync(dir).forEach(function(file) {
  const text = fs.readFileSync(`./${name}/${file}`, "utf8");

  const config = yml.parse(ejs.render(text, globle));

  config.tests.forEach(test => {
    ava(`${file} ${test.name}`, async t => {
      let req = superagent(test.method, host + test.api);

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
