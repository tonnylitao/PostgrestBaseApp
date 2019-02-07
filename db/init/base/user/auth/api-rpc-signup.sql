create extension if not exists pgcrypto;

--https://github.com/michelp/pgjwt make install
create extension if not exists pgjwt;

create function api.signup(name text, email text, password text) returns table (token text) as $$
declare
  _user_id uuid;
  _role public.user_role;

  _jwt record;
  _token text;

  _cookie text;
begin

  insert into data.users (name, email, password) values ($1, $2, crypt($3, gen_salt('bf')))
    returning id, role into _user_id, _role;

  if _user_id is null then
    raise invalid_password using message = 'invalid user or password';
  end if;

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
$$ language plpgsql SECURITY DEFINER;

revoke all privileges on function api.signup(text, text, text) from public;
grant execute on function api.signup(text, text, text) to app_anonym;
