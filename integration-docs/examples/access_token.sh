PARTNER_ID= your partner id
PARTNER_SECRET= your partner secret
API_HOST=public-api.wordpress.com

ACCESS_TOKEN_JSON=$(curl https://$API_HOST/oauth2/token \
  --silent \
  -d "grant_type=client_credentials&client_id=$PARTNER_ID&client_secret=$PARTNER_SECRET&scope=jetpack-partner")

ACCESS_TOKEN=$(echo $ACCESS_TOKEN_JSON | jq -r ".access_token")
