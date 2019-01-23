set search_path to api, public;

-- schema api
create or replace view api.companies as
	select * from data.companies;

-- Role
revoke all on api.companies from public;
GRANT SELECT ON api.companies TO public; --only view, not data

GRANT INSERT, UPDATE ON api.companies TO app_admin;

GRANT DELETE ON api.companies TO app_admin;
