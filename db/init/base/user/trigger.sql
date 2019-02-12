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
