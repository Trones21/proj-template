#!/bin/bash/
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "WARNING: This script should be sourced, not executed!"
  echo "Use: source ${0}"
  exit 1
fi

export ENV=development # this is used for cors and possibly other things
export DB_USER=app_user
export DB_PASS=
export DB_NAME=
export DB_HOST=0.0.0.0
export DB_PORT=5432
export BASE_URL=http://localhost:8080
export BREVO_API_KEY=
echo "Local backend env vars set"

