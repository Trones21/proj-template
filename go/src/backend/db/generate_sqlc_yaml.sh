#!/bin/bash

SCHEMA_DIR="./migrations"
QUERIES_DIR="./queries"
OUTPUT_DIR="./sqlcgen"
PACKAGE_NAME="db"

# Dynamically generate sqlc.yaml
cat <<EOL > sqlc.yaml
version: "1"
packages:
  - path: "$OUTPUT_DIR"
    name: "$PACKAGE_NAME"
    queries: "$QUERIES_DIR"
    schema:
EOL

# Add all schema directories
for dir in "$SCHEMA_DIR"/*; do
    if [ -d "$dir" ]; then
        echo "      - \"$dir\"" >> sqlc.yaml
    fi
done

# Add engine
cat <<EOL >> sqlc.yaml
    engine: "postgresql"
EOL

echo "Generated sqlc.yaml:"
cat sqlc.yaml
