
CREATE OR REPLACE FUNCTION app_company_id()
RETURNS int STABLE LANGUAGE SQL
AS $$
    select nullif(current_setting('request.jwt.claim.company_id', true), '')::int;
$$;
