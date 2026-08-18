#!/bin/sh

# Fix permissions on the data directory and any existing files
# This handles the case where files were created by root in previous container versions
chown -R nodejs:nodejs /app

# Start the application as the nodejs user
exec npm start
