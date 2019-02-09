set search_path to data, public;

-- schema data

create table if not exists data.users (
	id          serial primary key,
	created_at	timestamptz not null default now(),
	updated_at	timestamptz not null default now(),

	name        text not null,
	email				text not null unique,
	"password"	text not null, -- crypt('1234567', gen_salt('bf'))
	"role"      public.user_role not null default 'app_user',

	check (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
	check (length(password) < 512),
	check (role in ('app_user', 'app_admin'))
);

-- register

create trigger update_updated_at
	before update on data.users
	for each row execute procedure data.trigger_update_update_at();

--

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
	for each row execute procedure data.encrypt_pass();

-- row level policy
-- 注意，rlp并不会影响到view的查询，即使对table的select增加了限制，view也仍然被暴露
alter table data.users enable row level security;


create policy users_user_s on data.users
  for select
  to app_user
  using ( id = request.user_id() );

create policy users_user_u on data.users
  for update
  to app_user
  using ( id = request.user_id() );

create policy users_anonym_s on data.users
  for select
  to app_anonym
  using ( true );
