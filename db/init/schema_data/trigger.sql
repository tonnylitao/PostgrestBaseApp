CREATE TRIGGER posts_notify AFTER INSERT OR UPDATE OR DELETE ON data.posts
FOR EACH ROW EXECUTE PROCEDURE notify_trigger (
  'id'
);

CREATE FUNCTION notify_trigger() RETURNS trigger AS $trigger$
DECLARE
  rec RECORD;
  payload TEXT;
  column_name TEXT;
  column_value TEXT;
  payload_items JSONB;
BEGIN
  -- Set record row depending on operation
  CASE TG_OP
  WHEN 'INSERT', 'UPDATE' THEN
     rec := NEW;
  WHEN 'DELETE' THEN
     rec := OLD;
  ELSE
     RAISE EXCEPTION 'Unknown TG_OP: "%". Should not occur!', TG_OP;
  END CASE;

  -- Get required fields
  FOREACH column_name IN ARRAY TG_ARGV LOOP
    EXECUTE format('SELECT $1.%I::TEXT', column_name)
    INTO column_value
    USING rec;
    payload_items := coalesce(payload_items,'{}')::jsonb || json_build_object(column_name,column_value)::jsonb;
  END LOOP;

  -- Build the payload
  payload := json_build_object(
    'timestamp',CURRENT_TIMESTAMP,
    'operation',TG_OP,
    'schema',TG_TABLE_SCHEMA,
    'table',TG_TABLE_NAME,
    'data',payload_items
  );

  -- Notify the channel
  PERFORM pg_notify('db_notifications', payload);

  RETURN rec;
END;
$trigger$ LANGUAGE plpgsql;

--

CREATE OR REPLACE FUNCTION data.trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER update_updated_at BEFORE UPDATE ON data.users
FOR EACH ROW EXECUTE PROCEDURE data.trigger_set_timestamp();
