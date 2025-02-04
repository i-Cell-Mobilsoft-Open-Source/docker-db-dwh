CREATE OR REPLACE FUNCTION partman.insert_logs(dbname TEXT, modul TEXT, message TEXT)
RETURNS void
AS
$BODY$
DECLARE
v_sql TEXT;
  v_connstring TEXT;
BEGIN
  v_connstring := format('dbname=%s user=postgres port=5432', dbname);
  PERFORM public.dblink_connect('conn',v_connstring);
  v_sql := format('INSERT INTO partman.logs (id, modul, msg) VALUES (gen_random_uuid(), ''%s'', ''%s'')', modul,  message);
  PERFORM public.dblink_exec('conn',v_sql);
  PERFORM public.dblink_disconnect('conn');
END;
$BODY$
LANGUAGE plpgsql;
