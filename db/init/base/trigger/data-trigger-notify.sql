create function data.notify_trigger() returns trigger as $trigger$
declare
  rec record;
  payload text;
  column_name text;
  column_value text;
  payload_items jsonb;
begin
  -- set record row depending on operation
  case TG_OP
  when 'INSERT', 'UPDATE' then
     rec := NEW;
  when 'DELETE' then
     rec := OLD;
  else
     raise exception 'unknown tg_op: "%". should not happen!', tg_op;
  end case;

  -- get required fields
  foreach column_name in array TG_ARGV loop
    execute format('select $1.%I::text', column_name) into column_value using rec;

    payload_items := coalesce(payload_items,'{}')::jsonb || json_build_object(column_name,column_value)::jsonb;
  end loop;

  -- build the payload
  payload := json_build_object(
    'timestamp',CURRENT_TIMESTAMP,
    'operation',TG_OP,
    'schema',TG_TABLE_SCHEMA,
    'table',TG_TABLE_NAME,
    'data',payload_items
  );

  -- notify the channel
  perform pg_notify('db_notifications', payload);

  return rec;
end;
$trigger$ language plpgsql;
