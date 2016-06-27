#!/bin/bash
SALT_URL=${SALT_URL:-http://localhost:8888}
SALT_USERNAME=${SALT_USERNAME:-remotesalt}
SALT_PASSWORD=${SALT_PASSWORD:-59r{Y3*912}

LOGIN_RESULT=$(curl -sSk ${SALT_URL}/login -d eauth=pam  -d username="${SALT_USERNAME}" -d password="${SALT_PASSWORD}")

API_TOKEN=$(python -c $'import json\nimport sys\nprint sys.argv[1]\nprint json.loads(sys.argv[1])["return"][0]["token"]' $'${LOGIN_RESULT}')
curl -sSk ${SALT_URL}/jobs -H 'Accept: application/x-yaml'  -H "X-Auth-Token: ${SALT_TOKEN}"
