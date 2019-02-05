create extension if not exists pgcrypto;

create or replace function public.find_user_id(p_email text, p_password text) returns uuid
  language plpgsql
  as $$
begin
  return (
    select id from data.users
     where email = lower(p_email) and password = crypt(p_password, password)
  );
end;
$$;

--
--grant usage on schema data to app_anonym;
grant select on data.users to app_anonym;

--https://github.com/michelp/pgjwt make install
create extension if not exists pgjwt;

-- drop function api.login(text,text);
create function api.login(email text, password text) returns table (token text) as $$
declare
  _user_id uuid;
  _role data.user_role;

  _jwt record;
  _token text;

  _cookie text;
begin

  -- check email and password
  select public.find_user_id(email, password) into _user_id;

  if _user_id is null then
    raise invalid_password using message = 'invalid user or password';
  end if;

  select role from data.users where id = _user_id into _role;

  select
    _user_id as user_id,
    _role as role,
    extract(epoch from now() + '1 week'::interval)::integer as exp
  into _jwt;

  _token := sign(row_to_json(_jwt), current_setting('app.jwt_secret', false));

  -- 1 week
  _cookie := format('[{"set-cookie": "access_token=%s; path=/; max-age=604800"}]', _token);
  perform set_config('response.headers', _cookie, true);
  -- raise notice '%', _cookie;

  return query select _token;
end;
$$ language plpgsql;

revoke all privileges on function api.login(text, text) from public;
grant execute on function api.login(text,text) to app_anonym;
