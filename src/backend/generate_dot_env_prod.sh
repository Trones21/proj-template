
# See backend readme.. this is how we pull the env vars into docker 
# more secure than just copying over or using build args, b/c this is only available while container is running  
# which of course means that .env_prod needs to be specified anytime you start the container

#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ~/env_setup/pk_projName/prod_backend.sh
env | grep -E 'ENV|DB_HOST|DB_PORT|DB_USER|DB_PASS|DB_NAME|BREVO_API_KEY' > "$SCRIPT_DIR/.env_prod"
echo "Environment variables saved to $SCRIPT_DIR/.env_prod"
