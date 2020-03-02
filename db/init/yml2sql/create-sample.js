const ejs = require('ejs')
const fs = require('fs')
const yml = require('yaml')
const async = require('async')
const path = require('path')
const faker = require('faker')
const csvstringify = require('csv-stringify')
const R = require('ramda')

function randomId() {
  return Math.max(Math.floor(Math.random() * 100), 10);
}

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
        defaults: defaultUsers,
        columns: {
          id: i => i,
          name: faker.internet.userName,
          email: i => i + faker.internet.email(), //unique
          password: faker.internet.password,
          avatar: faker.image.avatar,
          role: () => ["app_user", "app_admin"][Math.random() > 0.3 ? 0 : 1]
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
          user_id: i => i,
          group_id: i => i
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
  //   ecommerce: ["store", "product", "address", "order", "payment"]
  // }
];

module.exports = function(dir) {
  fs.mkdirSync(dir);

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
    ({ tableName, count, defaults = [], columns, appName }, callback) => {
      const columnNames = Object.keys(columns);

      const rows = R.concat(
        defaults,
        R.range(defaults.length + 1, count).map(i => {
          const obj = columnNames.reduce((rel, item) => {
            rel[item] = columns[item](i);
            return rel;
          }, {});

          return obj;
        })
      );

      csvstringify(rows, async (err, csv) => {
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

        if (columns.id)
          init += `select setval('data.${tableName}_id_seq', (select max(id) from data.${tableName}));\n\n`;

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
