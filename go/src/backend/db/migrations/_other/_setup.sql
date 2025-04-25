DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user') THEN
        GRANT CONNECT ON DATABASE pk_projName TO app_user;
    ELSE
        RAISE NOTICE 'Role app_user does not exist.';
    END IF;
END $$;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS "marketing"; 