create function create_application_roles(login_role text, schema text, roles text[]) returns void as $$
declare r record;
begin
for r in
   select unnest(roles) as name
loop
   -- execute 'drop role if exists ' || quote_ident(r.name);
   execute 'create role ' || quote_ident(r.name);
   execute 'grant ' || quote_ident(r.name) || ' to ' || login_role;
   execute 'grant usage on schema ' || schema || ' to ' || quote_ident(r.name);
end loop;
end;
$$  language plpgsql;

revoke all privileges on function create_application_roles(text,text,text[]) from public;


create type user_role as enum ('app_anonym', 'app_user', 'app_admin');

select create_application_roles(:'app_db_login_user', :'app_db_schema', enum_range(null::user_role)::text[]);

drop function create_application_roles(text, text[]);
