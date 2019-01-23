-- \set app_db_login_user `echo $APP_DB_LOGIN_USER`
-- \set app_db_schema `echo $APP_DB_SCHEMA`

-- set roles for whole app

CREATE type user_role as enum ('app_anonym', 'app_user', 'app_admin');


select create_application_roles(:'app_db_login_user', :'app_db_schema', enum_range(null::user_role)::text[]);
-- drop function create_application_roles(text, text[]);
