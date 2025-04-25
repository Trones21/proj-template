#!/bin/bash

# Hardcoded to avoid dropping in prod
# DB_USER="postgres"
# DB_PASS="postgres"
# DB_HOST="0.0.0.0"
# DB_PORT="5432"
# DB_NAME="pk_projName"
 
export PGPASSWORD=$DB_PASS


echo "DB: $DB_HOST:$DB_PORT Are you sure you want to drop the database? (yes/no) . *******DO NOT RUN AGAINST PROD DB (run the backup_and_recreate script instead) *******"
read answer
if [ "$answer" != "yes" ]; then
    echo "Aborting."
    exit 1
fi

if [ "$ENV" == "production" ]; then
    echo "🔥 NOT DROPPING PROD 🔥... Lots of safeguards in place..."
    exit 1
fi

# Fetch all tables in all schemas
tables=$(psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -Atc "
SELECT 'DROP TABLE IF EXISTS ' || quote_ident(schemaname) || '.' || quote_ident(tablename) || ' CASCADE;'
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema');
")

# Exit if no tables are found
if [[ -z "$tables" ]]; then
    echo "No tables found to drop."
    exit 0
fi

# Drop all tables
echo "Dropping all tables in the database..."
echo "$tables" | psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME"

unset PGPASSWORD

echo "Script Finished"
