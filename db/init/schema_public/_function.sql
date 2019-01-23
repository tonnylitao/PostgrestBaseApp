set search_path to public;

CREATE OR REPLACE FUNCTION app_user_id()
RETURNS int STABLE LANGUAGE SQL
AS $$
    select nullif(current_setting('request.jwt.claim.user_id', true), '')::int;
$$;

--

create or replace function create_application_roles(login_role text, schema text, roles text[]) returns void as $$
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

-- DROP FUNCTION public.pre_request();
-- create or replace function public.pre_request() returns void
--   language plpgsql
--   as $$
--   declare
-- access_token text;
-- auth text;
-- begin
-- 	access_token := current_setting('request.cookie.access_token', true);
--
-- 	if current_setting('request.header.authorization', true) isnull then
-- 		auth := CONCAT('Bearer ', access_token);
--  		set local "request.header.authorization" = auth; --失败
-- 	end if;
-- end
-- $$;
