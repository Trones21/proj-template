# So we implemented this X-Sib-Sandbox to try and sandbox our requests, but found that Brevo does not do this for every endpoint.
# Therefore for testing we will just obtained a 2nd account and added an api key for that account to ~/env_setup/pk_projName/local_backend.sh 


#!/bin/bash

BREVO_API_KEY=$BREVO_API_KEY

#Sample body data
TEST_EMAIL="test@example.com"
SIGNUP_LINK="https://example.com/signup?token=abc123"

# Check if the API key is set
if [ -z "$BREVO_API_KEY" ]; then
  echo "Error: BREVO_API_KEY is not set. Please update the script with your API key."
  exit 1
fi

# Make the API call
curl -X POST "https://api.brevo.com/v3/contacts" \
-H "accept: application/json" \
-H "content-type: application/json" \
-H "api-key: $BREVO_API_KEY" \
-d "{
  \"updateEnabled\": true,
  \"email\": \"$TEST_EMAIL\",
  \"signup_link\": \"$SIGNUP_LINK\",
  \"headers\": {
    \"X-Sib-Sandbox\": \"drop\"
  }
}"
