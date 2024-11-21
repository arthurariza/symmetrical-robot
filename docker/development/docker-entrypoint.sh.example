#!/bin/bash
set -e

# If a server.pid file exists, remove it (ensures a clean start)
if [ -f tmp/pids/server.pid ]; then 
    rm tmp/pids/server.pid
fi

# Execute the passed command (in our case, "bin/rails s -b 0.0.0.0")
exec "$@"
