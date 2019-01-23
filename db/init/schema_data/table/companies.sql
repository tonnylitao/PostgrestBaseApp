set search_path to data, public;

-- schema data
CREATE TABLE IF NOT EXISTS data.companies (
	id                   serial primary key,
	name                 text not null
);

-- Row Level Policy
-- 注意，RLP并不会影响到view的查询，即使Select增加了限制，View也仍然被暴露
ALTER TABLE data.companies ENABLE ROW LEVEL SECURITY;

CREATE POLICY companies_admin_SIUD ON data.companies TO app_admin
  USING ( id = app_company_id() );

CREATE POLICY companies_user_S ON data.companies
  FOR SELECT TO app_user
  USING ( id = app_company_id() );

CREATE POLICY companies_anonym_S ON data.companies
  FOR SELECT TO app_anonym
  USING ( true );
