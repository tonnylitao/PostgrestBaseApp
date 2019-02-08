set search_path to public;

create or replace function app_group_id()
returns int stable language sql
as $$
    select nullif(current_setting('request.jwt.claim.group_id', true), '')::int;
$$;
