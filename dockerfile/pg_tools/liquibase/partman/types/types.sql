DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE lower(typname) = 'check_default_table') THEN
        CREATE TYPE partman.check_default_table AS (default_table text, count bigint) ;
    END IF;
END $$;