#!/bin/sh

set -e

echo "run db migration"
# Load environment variables from app.env, handling quoted values properly
set -a
. /app/app.env
set +a
/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@" 