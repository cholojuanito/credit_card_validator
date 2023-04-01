#!/usr/bin/env bash
# This script creates/updates credentials.json file which is used
# to authorize publisher when publishing packages to pub.dev

RED='\033[0;31m'

errln() {
    echo "❌ $RED Error: $1"
    exit 1
}

# Checking whether the secrets are available as environment
# variables or not.
if [ -z "${PUB_DEV_PUBLISH_ACCESS_TOKEN}" ]; then
  errln "Missing PUB_DEV_PUBLISH_ACCESS_TOKEN environment variable"
fi

if [ -z "${PUB_DEV_PUBLISH_REFRESH_TOKEN}" ]; then
  errln "Missing PUB_DEV_PUBLISH_REFRESH_TOKEN environment variable"
fi

if [ -z "${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}" ]; then
  errln "Missing PUB_DEV_PUBLISH_TOKEN_ENDPOINT environment variable"
fi

if [ -z "${PUB_DEV_PUBLISH_EXPIRATION}" ]; then
  errln "Missing PUB_DEV_PUBLISH_EXPIRATION environment variable"
fi

# creates directory to store creditionals
if [ ! -d "~/.pub-cache" ]; then
    mkdir ~/.pub-cache
fi

# Create credentials.json file.
echo "📝 Writing credentials"
cat <<EOF > ~/.pub-cache/credentials.json
{
  "accessToken":"${PUB_DEV_PUBLISH_ACCESS_TOKEN}",
  "refreshToken":"${PUB_DEV_PUBLISH_REFRESH_TOKEN}",
  "tokenEndpoint":"${PUB_DEV_PUBLISH_TOKEN_ENDPOINT}",
  "scopes":["https://www.googleapis.com/auth/userinfo.email","openid"],
  "expiration":${PUB_DEV_PUBLISH_EXPIRATION}
}
EOF

echo "🔑 Credentials checksum"
sha1sum -b ~/.pub-cache/credentials.json
