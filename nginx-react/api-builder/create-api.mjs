import fs from "fs";
import yml from "yaml";

export default function(dir) {
  // fs.mkdirSync(dir);

  ["user", "admin"].forEach(item => {
    buildApiForRole(item, result => {
      const data = JSON.stringify(result, null, 2);
      fs.writeFile(
        `${dir}/${item}.js`,
        apiFile(data.replace(/"/g, "")),
        err => {
          if (err) console.error(err);
        }
      );
    });
  });
}

function buildApiForRole(role, callback) {
  fs.readdir("./yml", function(err, items) {
    return callback(
      items
        .filter(folder => folder !== ".DS_Store")
        .reduce((res, acl) => {
          return {
            ...res,
            [acl]: {
              ...res[acl],
              ...buildApiMethodsForFolder(acl, role)
            }
          };
        }, {})
    );
  });
}

function buildApiMethodsForFolder(folder, role) {
  const arr = fs
    .readdirSync(`./yml/${folder}`)
    .filter(item => item !== ".DS_Store");

  return arr.reduce((res, acl) => {
    const text = fs.readFileSync(`./yml/${folder}/${acl}`, "utf8");
    const config = yml.parse(text);

    const data = (config.view || [])
      .map(item => {
        const roleMethods = (item.rest || []).map(item => {
          const tmp = item.split(".");
          const method = tmp[1].split("(")[0].split("_")[1];

          return {
            role: tmp[0].split("_")[1] || tmp[0],
            method
          };
        });

        return {
          name: item.name,
          roleMethods
        };
      })
      .map(({ name: view, roleMethods }) => {
        const pub = roleMethods
          .filter(item => item.role === "public")
          .reduce(
            (rel, acl) => ({
              ...rel,
              [acl.method]: findApiFunction(view, acl.method)
            }),
            {}
          );

        const target = roleMethods
          .filter(item => item.role === role)
          .reduce(
            (rel, acl) => ({
              ...rel,
              [acl.method]: findApiFunction(view, acl.method)
            }),
            {}
          );

        const methods = { ...pub, ...target };

        return {
          view,
          methods
        };
      })
      .filter(item => Object.keys(item.methods).length > 0)
      .reduce((res, acl) => {
        return {
          [acl.view]: {
            ...res[acl.view],
            ...acl.methods
          }
        };
      }, {});

    return {
      ...res,
      ...data
    };
  }, {});
}

function apiFile(data) {
  return `import axios from 'axios';
import config from "./config.js";

const restAppId = process.env.REST_APP_ID;
const token = process.env.token;

const instance = axios.create({
  baseURL: config.apiHost,
  timeout: 180000,
  headers: {
    "X-App-Id": restAppId
  }
});

axios.interceptors.request.use(function (config) {
  config.headers.Authorization = \`Bearer \${token}\`;

  return config;
}, function (error) {
  return Promise.reject(error);
});

export default ${data}`;
}

function findApiFunction(name, method) {
  const map = {
    get: `params => instance.get('/${name}', { params })`,
    post: `data => instance.post('/${name}', data)`,
    patch: `data => instance.patch('/${name}', data)`,
    delete: `id => instance.delete(\`/${name}?id=\${id}\`)`
  };
  return map[method];
}
