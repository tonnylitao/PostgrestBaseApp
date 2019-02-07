set search_path to public;

create function create_rest(roles text[], method text, view text) returns void as $$
declare r record;
begin
for r in
   select unnest(roles) as name
loop

   if method = 'GET' then
     execute 'grant select on api.' || quote_ident(view) || ' to ' || quote_ident(r.name);
   elsif method = 'POST' then
     execute 'grant insert on api.' || quote_ident(view) || ' to ' || quote_ident(r.name);
   elsif method = 'PATCH' then
     execute 'grant update on api.' || quote_ident(view) || ' to ' || quote_ident(r.name);
   elsif method = 'DELETE' then
     execute 'grant delete on api.' || quote_ident(view) || ' to ' || quote_ident(r.name);
   end if;

end loop;
end;
$$  language plpgsql;

revoke all privileges on function create_rest(text[],text,text) from public;
