set search_path to data, public;

alter table data.users add column company_id int references data.companies(id) default public.app_company_id();
CREATE INDEX IF NOT EXISTS "data.users_company_id_index" on data.users(company_id);


CREATE POLICY users_admin_SIUD ON data.users
  TO app_admin
  USING ( company_id = public.app_company_id() );
