#!/bin/bash
### The purpose of this is to persist tars just in case i end up overwriting one that i didnt mean too... maybe not on a feature branch or whatever.. etc.
# Get today's date in YYYYMMDD format
TODAY=$(date +%Y%m%d)

# Define source and destination directories
SOURCE_FILE="filename"
DEST_DIR="/path/to/destination"
DEST_FILE="${DEST_DIR}/${TODAY}_filename"

# Check if the file already exists in the destination
if [ ! -e "$DEST_FILE" ]; then
    mv "$SOURCE_FILE" "$DEST_FILE"
    echo "Moved $SOURCE_FILE to $DEST_FILE"
else
    echo "File $DEST_FILE already exists. Skipping move."
fi
