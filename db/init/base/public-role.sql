set search_path to public;

create function create_application_roles(login_role text, schema text, roles text[]) returns void as $$
declare r record;
begin
for r in
   select unnest(roles) as name
loop
   execute 'create role ' || quote_ident(r.name);
   execute 'grant ' || quote_ident(r.name) || ' to ' || login_role;
   execute 'grant usage on schema ' || schema || ' to ' || quote_ident(r.name);

   perform create_schema_for_role(r.name);
end loop;
end;
$$ language plpgsql;
revoke all privileges on function create_application_roles(text,text,text[]) from public;

--
create function create_schema_for_role(role_name text) returns void as $$
begin
  execute 'create schema ' || quote_ident(role_name);

  execute format('create function %1$s.rest_get(view text, columns text default '''') returns void as $GET$
    begin
       perform public.rest_get(view, columns, %1$L);
    end;
    $GET$ language plpgsql;
    revoke all privileges on function %1$s.rest_get(text, text) from public;

    --
    create function %1$s.rest_post(view text, columns text default '''') returns void as $GET$
    begin
       perform public.rest_post(view, columns, %1$L);
    end;
    $GET$ language plpgsql;
    revoke all privileges on function %1$s.rest_post(text, text) from public;

    --
    create function %1$s.rest_patch(view text, columns text default '''') returns void as $GET$
    begin
       perform public.rest_patch(view, columns, %1$L);
    end;
    $GET$ language plpgsql;
    revoke all privileges on function %1$s.rest_patch(text, text) from public;

    --
    create function %1$s.rest_delete(view text) returns void as $GET$
    begin
       perform public.rest_delete(view, %1$L);
    end;
    $GET$ language plpgsql;
    revoke all privileges on function %1$s.rest_delete(text) from public;', role_name);

  execute format('create function %1$s.rlp_select(table_name text, using_expression text default ''true'') returns void as $GET$
    begin
      execute public.rlp_select(table_name, using_expression, %1$L);
    end;
    $GET$ language plpgsql;
    revoke all privileges on function %1$s.rlp_select(text, text) from public;

    --
    create function %1$s.rlp_insert(table_name text, check_expression text default ''true'') returns void as $GET$
    begin
      execute public.rlp_insert(table_name, check_expression, %1$L);
    end;
    $GET$ language plpgsql;
    revoke all privileges on function %1$s.rlp_insert(text, text) from public;

    --
    create function %1$s.rlp_update(table_name text, using_expression text default ''true'') returns void as $GET$
    begin
      execute public.rlp_update(table_name, using_expression, %1$L);
    end;
    $GET$ language plpgsql;
    revoke all privileges on function %1$s.rlp_update(text, text) from public;

    --
    create function %1$s.rlp_delete(table_name text, using_expression text default ''true'') returns void as $GET$
    begin
      execute public.rlp_delete(table_name, using_expression, %1$L);
    end;
    $GET$ language plpgsql;
    revoke all privileges on function %1$s.rlp_delete(text, text) from public', role_name);
end;
$$ language plpgsql;
revoke all privileges on function create_schema_for_role(text) from public;

--
create type user_role as enum ('app_anonym', 'app_user', 'app_admin');

select create_application_roles(:'app_db_login_user', :'app_db_schema', enum_range(null::user_role)::text[]);

drop function create_application_roles(text,text,text[]);
drop function create_schema_for_role(text);
