#!/bin/bash

# Hardcoding variables so we dont accidentally drop prod
HOST="0.0.0.0"
PORT="5432"
USER="postgres"
PASSWORD="postgres"
DB_NAME=""

export PGPASSWORD="$PASSWORD"

# -d postgres explanation: We need to connect to another database (postgres) to perform the drop of pk_projName

# Remove any sessions (This will block dropping)
psql -U postgres -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'pk_projName' AND pid <> pg_backend_pid();"
# Drop the database
psql -h "$HOST" -p "$PORT" -U "$USER" -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;"

# Recreate the database
psql -h "$HOST" -p "$PORT" -U "$USER" -d postgres -c "CREATE DATABASE $DB_NAME;"
