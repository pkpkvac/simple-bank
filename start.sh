#!/bin/sh

set -e

echo "run db migration"
# Load environment variables - use a simple approach that works with /bin/sh
# The app.env file should have values properly quoted for values with special chars
. /app/app.env

/app/migrate -path /app/migration -database "$DB_SOURCE" -verbose up

echo "start the app"
exec "$@" 