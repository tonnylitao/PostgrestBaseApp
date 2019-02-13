import ejs from "ejs";
import fs from "fs";
import yml from "yaml";
import async from "async";
import path from "path";
import faker from "faker";
import csvstringify from "csv-stringify";

function randomId() {
  return Math.max(Math.floor(Math.random() * 100), 10);
}

export default function(dir) {
  fs.mkdirSync(dir);

  const defaultUsers = [
    {
      id: 1,
      name: "user1",
      email: "user1@app.com",
      password: "aaaaaa",
      avatar: faker.image.avatar(),
      role: "app_user"
    },
    {
      id: 2,
      name: "admin1",
      email: "admin1@app.com",
      password: "1234567",
      avatar: faker.image.avatar(),
      role: "app_admin"
    }
  ];

  const services = [
    {
      community: [
        {
          tableName: "users",
          count: 100,
          columns: {
            id: i => i + 2,
            name: faker.internet.userName,
            email: faker.internet.email,
            password: faker.internet.password,
            avatar: faker.image.avatar,
            role: () => ["app_user", "app_admin"][Math.random() > 0.5 ? 0 : 1]
          }
        },
        {
          tableName: "groups",
          count: 100,
          columns: {
            id: i => i,

            name: faker.random.word,

            user_id: randomId
          }
        },
        {
          tableName: "posts",
          count: 100,
          columns: {
            id: i => i,

            title: faker.random.words,
            body: faker.random.words,

            user_id: randomId,
            group_id: randomId
          }
        },
        {
          tableName: "usergroups",
          count: Math.random() * 100 + 10,
          columns: {
            user_id: randomId,
            group_id: randomId
          }
        },
        {
          tableName: "stars",
          count: Math.random() * 100 + 10,
          columns: {
            user_id: randomId,
            post_id: randomId
          }
        },
        {
          tableName: "follows",
          count: Math.random() * 100 + 10,
          columns: {
            from_id: randomId,
            to_id: randomId
          }
        },
        {
          tableName: "messages",
          count: Math.random() * 100 + 10,
          columns: {
            body: faker.random.words,

            from_id: randomId,
            to_id: randomId
          }
        },
        {
          tableName: "comments",
          count: Math.random() * 100 + 10,
          columns: {
            body: faker.random.words,

            user_id: randomId,
            post_id: randomId
          }
        }
      ]
    }
    // {
    // ecommerce: ["store", "product", "address", "order", "payment"]
    // }
  ];

  const tables = services
    .map(item => {
      const appName = Object.keys(item)[0];
      fs.mkdirSync(`${dir}/${appName}`);

      const tables = item[appName];
      return tables.map(item => ({ ...item, appName }));
    })
    .reduce((acc, val) => acc.concat(val), []);

  let init = "";
  async.mapSeries(
    tables,
    ({ tableName, count, columns, appName }, callback) => {
      const columnNames = Object.keys(columns);

      let arr = tableName === "users" ? [...defaultUsers] : [];
      let temp = "";
      for (let i = 1; i < count; i++) {
        let obj = {};

        columnNames.forEach(item => {
          obj[item] = columns[item](item === "id" ? i : undefined);
        });

        const t = JSON.stringify(obj);
        if (temp.indexOf(t) === -1) {
          temp += t;

          arr.push(obj);
        }
      }

      csvstringify(arr, async (err, csv) => {
        const data = await fs.writeFile(
          `${dir}/${appName}/${tableName}.csv`,
          csv,
          err => {
            if (err) console.error(err);
          }
        );

        init += `COPY data.${tableName}(${columnNames.join(
          ","
        )}) FROM '/docker-entrypoint-initdb.d/yml2sql/build/sample/${appName}/${tableName}.csv' DELIMITER ',' CSV;\n`;

        callback();
      });
    },
    (err, results) => {
      if (err) console.error(err);

      fs.writeFile(`${dir}/init.sql`, init, err => {
        if (err) console.error(err);
      });
    }
  );
}
