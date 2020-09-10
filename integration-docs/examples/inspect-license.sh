. $(dirname "$0")/access_token.sh

LICENSE_KEY= your license key

LICENSE_JSON=$(curl "https://${API_HOST}/wpcom/v2/jetpack-licensing/license?license_key=${LICENSE_KEY}" \
  --silent \
  --header "authorization: Bearer $ACCESS_TOKEN")
echo $LICENSE_JSON
