--debug
set search_path to api, public;

CREATE OR REPLACE FUNCTION debug_user_id()
RETURNS int STABLE LANGUAGE SQL
AS $$
    select nullif(current_setting('request.jwt.claim.user_id', true), '')::int;
$$;
