Docker + PostgreSQL + PostgREST + Nginx + NodeJS apps + React apps + API Test

- Nginx for serving React apps as static files
- NodeJS for backend service
- PostgREST for Restful api
- PostgreSQL, the best database in the world
- API Test, ava + superagent to test asserts declared in YML files

#### Nginx ⇋ React apps

Nginx is ideal for static files, you only need to

  - change PUBLIC_URL in react apps when run npm
  - add the path in react router

```
"build": "PUBLIC_URL=/app react-scripts build",


<Route path="/app" component={Application} />
```

#### Nginx ⇋ PostgREST

- Nginx routes `/api` to PostgreREST
- Nginx controls the access of api

#### Nginx ⇋ NodeJS

- Nginx as reverse proxy for NodeJS apps

#### NodeJS ⇋ React apps

- socket.io

#### NodeJS ⇋ Postgresql

- [listen/notify](https://www.postgresql.org/docs/current/sql-notify.html)

------

### Run locally

```
# sh dev.sh
```

- localhost:3001 -> React app1
- localhost:3002 -> React app2
- localhost:9001/node -> NodeJS
- localhost:9001/api -> Postgrest

![](assets/structure_local.jpg)


#### Feature

- in database design, `data` schema and `api` schema is separated
- use role and Row Level Policy for ACL
- create view to hide column in api
- login and register
- use cookie after login
- Postgres notify, NodeJS listen, socket.io post to web

#### TODO

- pre-request validation
- blacklist
- send email
- auth login: wechat/facebook
- token refresh
- HTTPS Everywhere
- 3 subsystems: app/community, app/ecommerce, app/financial

#### How to send email?

##### 1. simplified way

1. add trigger on insert table mail
2. send notification with payload in the trigger function
3. use Nodejs to receive the notification
4. send mail in Nodejs

##### 2. complex way

Postgres notify -> NodeJS -> RabbitMQ -> Mailer
