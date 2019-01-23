set search_path to data, public;

-- schema data

CREATE TABLE IF NOT EXISTS data.users (
	id          serial primary key,
	created_at	timestamptz not null default now(),
	updated_at	timestamptz not null default now(),

	name        text not null,
	email				text not null UNIQUE,
	"password"	text not null, -- crypt('1234567', gen_salt('bf'))
	"role"      public.user_role not null default 'app_user',

	check (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
	check (length(password) < 512),
	check (role in ('app_admin', 'app_user'))
);

-- for register

create or replace function data.encrypt_pass() returns trigger as $$
begin
  if new.password is not null then
  	new.password = public.crypt(new.password, public.gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;

create trigger users_encrypt_password_trigger
	before insert or update on data.users
	for each row
	execute procedure data.encrypt_pass();

-- Row Level Policy
-- 注意，RLP并不会影响到view的查询，即使对table的Select增加了限制，View也仍然被暴露
ALTER TABLE data.users ENABLE ROW LEVEL SECURITY;


CREATE POLICY users_user_S ON data.users
  FOR SELECT
  TO app_user
  USING ( id = public.app_user_id() );

CREATE POLICY users_user_U ON data.users
  FOR UPDATE
  TO app_user
  USING ( id = public.app_user_id() );

CREATE POLICY users_anonym_S ON data.users
  FOR SELECT
  TO app_anonym
  USING ( true );
