import ejs from "ejs";
import fs from "fs";
import yml from "yaml";
import async from "async";
import path from "path";
import mkdirp from "mkdirp";
import rimraf from "rimraf";

const apps = [
  {
    community: [
      "user",
      "group",
      "post",
      "star",
      "message",
      "comment",
      "follow",
      "usergroup"
    ],
    ecommerce: [],
    financial: []
  }
];

const dir = "./build";
rimraf.sync(dir);
fs.mkdirSync(dir);

const tables = apps
  .map(item => {
    const appName = Object.keys(item)[0];
    fs.mkdirSync(`${dir}/${appName}`);

    const tables = item[appName];
    return tables.map(item => `${appName}/${item}`);
  })
  .reduce((acc, val) => acc.concat(val), []);

let init = "";
async.mapSeries(
  tables,
  async name => {
    const text = fs.readFileSync(`./yml/${name}.yml`, "utf8");
    const config = yml.parse(text);

    const data = await ejs.renderFile("template.ejs", config);

    await fs.writeFile(`${dir}/${name}.sql`, data, console.log);

    init = init + `\\ir ${name}.sql\n`;
  },
  (err, results) => {
    console.log(err);

    fs.writeFile(`${dir}/init.sql`, init, console.log);
  }
);
