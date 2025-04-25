#!/bin/bash/
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "WARNING: This script should be sourced, not executed!"
  echo "Use: source ${0}"
  exit 1
fi

export ENV=production #This is used for CORS and possibly other things
export DB_USER=app_user
export DB_PASS=
export DB_NAME=
export DB_HOST=
export DB_PORT=5432
export BREVO_API_KEY=
export SSH_USER=
export SSH_SERVER=

echo " backend env vars set"

