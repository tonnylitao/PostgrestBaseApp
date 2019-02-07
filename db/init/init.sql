-- -- some setting to make the output less verbose
\set QUIET on
\set ON_ERROR_STOP on
set client_min_messages to warning;
--
-- -- load some variables from the env
-- \setenv base_dir :DIR
-- \set base_dir `if [ $base_dir != ":"DIR ]; then echo $base_dir; else echo "/docker-entrypoint-initdb.d"; fi`
-- \set anonymous `echo $DB_ANON_ROLE`
-- \set authenticator `echo $DB_USER`
-- \set authenticator_pass `echo $DB_PASS`

\set app_db_name `echo $POSTGRES_DB`

\set app_db_schema `echo $APP_DB_SCHEMA`

\set app_db_login_user `echo $APP_DB_LOGIN_USER`
\set app_db_password `echo $APP_DB_LOGIN_PASSWORD`

\set app_jwt_secret `echo $APP_JWT_SECRET`
\set app_is_development `echo $APP_IS_DEVELOPMENT`

create user :app_db_login_user with password :'app_db_password';

alter database :app_db_name owner to :app_db_login_user;

begin;

create schema api;
create schema data;

create extension pgcrypto schema public;
create extension pgjwt schema public;

-- base
\ir base/public-function-create-rest.sql
\ir base/public-function-create-row-policy.sql
\ir base/public-function-user-id.sql
\ir base/public-role.sql

  \ir base/trigger/data-trigger-notify.sql
  \ir base/trigger/data-trigger-updatedat.sql

  \ir base/setting/data-table.sql

  \ir base/user/data-table.sql
  \ir base/user/api-view.sql
  \ir base/user/auth/api-rpc-login.sql
  \ir base/user/auth/api-rpc-logout.sql
  \ir base/user/auth/api-rpc-signup.sql

-- app
\ir app/public-function.sql

  \ir app/community/group/data-table.sql
  \ir app/community/group/api-view.sql

  \ir app/community/post/data-table.sql
  \ir app/community/post/api-view.sql

  \ir app/user/data-table.sql
  \ir app/user/api-view.sql
-- dev
-- \if :app_is_development
  -- \ir base/user/auth/api-rpc-dev.sql
  \ir app/data-sample.sql
-- \endif

commit;

\echo # ==========================================
