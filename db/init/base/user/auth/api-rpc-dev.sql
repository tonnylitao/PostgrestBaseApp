--debug
set search_path to api, public;

create or replace function debug_user_id()
returns int stable language sql
as $$
    select nullif(current_setting('request.jwt.claim.user_id', true), '')::int;
$$;

create or replace function debug_user_role()
returns text stable language sql
as $$
    select nullif(current_setting('request.jwt.claim.role', true), '')::text;
$$;
