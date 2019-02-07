set search_path to public;

CREATE OR REPLACE FUNCTION app_group_id()
RETURNS int STABLE LANGUAGE SQL
AS $$
    select nullif(current_setting('request.jwt.claim.group_id', true), '')::int;
$$;
