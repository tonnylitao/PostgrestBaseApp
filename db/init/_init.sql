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
\ir schema_public/_function.sql
\ir schema_public/_role.sql

\ir schema_data/table/_users.sql
-- \ir schema_data/_settings.sql

\ir schema_api/view/_users.sql

-- app

\ir schema_data/table/companies.sql
\ir schema_data/table/users.sql
\ir schema_data/table/posts.sql

\ir schema_api/view/users.sql
\ir schema_api/view/posts.sql
\ir schema_api/view/companies.sql

-- create test data

\if :app_is_development
  \ir schema_api/rpc/_dev.sql
  \ir schema_data/sample_data.sql
\endif

commit;

\echo # ==========================================
