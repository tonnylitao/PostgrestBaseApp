set search_path to public;

CREATE OR REPLACE FUNCTION app_user_id()
RETURNS int STABLE LANGUAGE SQL
AS $$
    select nullif(current_setting('request.jwt.claim.user_id', true), '')::int;
$$;

--

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
