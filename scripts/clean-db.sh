#!/bin/bash

# Check for .env file
if [ ! -f .env ]; then
  echo "❌ .env file not found!"
  exit 1
fi

# Load env variables
export $(grep -v '^#' .env | xargs)

# Construct JDBC URL from env vars
DB_URL="jdbc:mysql://${DB_HOST}:${DB_PORT}/${DB_NAME}?ssl-mode=${DB_SSL_MODE}&serverTimezone=${DB_SERVER_TIMEZONE}"

# Clean database using Flyway
./mvnw flyway:clean \
  -Dflyway.cleanDisabled=false \
  -Dflyway.url="$DB_URL" \
  -Dflyway.user="$DB_USERNAME" \
  -Dflyway.password="$DB_PASSWORD"
