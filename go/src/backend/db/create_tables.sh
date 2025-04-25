#!/bin/bash

DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT

export PGPASSWORD=$DB_PASS
# Default values
SCHEMA=""

# Parse command-line options
while getopts "s:" opt; do
    case "$opt" in
        s) SCHEMA="$OPTARG" ;; # Capture the schema flag
        *) echo "Usage: $0 [-s schema_name]"; exit 1 ;;
    esac
done

# Base directory for migrations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIGRATIONS_DIR="$SCRIPT_DIR/migrations"

## Setup Tasks - Schemas, extensions, etc.
psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -f "$MIGRATIONS_DIR/_other/_setup.sql"


# Function to process files
process_files() {
    local target_dir="$1"
    echo "Processing files in: $target_dir"

    find "$target_dir" -type f -name "*.sql" | while IFS= read -r file; do
        output=$(psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -f "$file" 2>&1)
        partial_path="$(basename "$(dirname "$file")")/$(basename "$file")"
        if echo "$output" | grep -q "already exists"; then
            echo "$partial_path: already exists."
        else
            echo "$partial_path: $output"
        fi

    done
}

# Main logic
if [ -n "$SCHEMA" ]; then
    # Run only on the specified schema
    TARGET_DIR="$MIGRATIONS_DIR/tables/$SCHEMA"
    if [ ! -d "$TARGET_DIR" ]; then
        echo "Error: Schema directory '$TARGET_DIR' does not exist."
        exit 1
    fi
    process_files "$TARGET_DIR"
else
    # Run on all schemas
    process_files "$MIGRATIONS_DIR"
fi

echo "======================================"
# Check sql file count against table count 
echo "Counting tables/views against file count"
echo "Note: Script DOES NOT exclude any non table/view .sql files (e.g. _setup.sql)" 
echo "Remember to check table_count.sql to check that all schemas are included"
echo "Table $(psql --set ON_ERROR_STOP=on -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -f "table_count.sql")"
echo "File Count: $(find "$MIGRATIONS_DIR" -type f -name "*.sql" | wc -l)" 
