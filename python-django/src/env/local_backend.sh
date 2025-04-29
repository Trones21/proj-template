#!/bin/bash/
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "WARNING: This script should be sourced, not executed!"
  echo "Use: source ${0}"
  exit 1
fi

export ENV=development # this is used for cors and possibly other things

export DB_USER=postgres
export DB_PASS=postgres
export DB_NAME=pk_projName
export DB_HOST=0.0.0.0
export DB_PORT=5432

export APP_PORT="8000"

export BASE_URL=http://localhost:8080
export BREVO_API_KEY=
 
# # Not used for local dev Set S3 env vars
# export top_level_bucket=""
# export S3_ACCESS_KEY=""
# export S3_SECRET_KEY=""

export DJANGO_KEY="django-insecure-er(28vzqa)7_^n+wmqn@)3=1)eup#m*!lr49j!bzdu&!ai$=hu'"
export DJANGO_CORS="http://localhost:9443"

echo "Local backend env vars set"