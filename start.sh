#!/bin/sh

set -e

echo "run db migration"
# Load only DB_SOURCE from app.env for migration (avoid issues with special chars in other vars)
# Use grep and sed to extract just DB_SOURCE line and export it
export DB_SOURCE=$(grep "^DB_SOURCE=" /app/app.env | cut -d'=' -f2-)

/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
# The Go app will load all env vars from app.env using viper, so we don't need to export them here
exec "$@" 