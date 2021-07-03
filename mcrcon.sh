#!/usr/bin/env sh

export MCRCON_HOST='127.0.0.1'
export MCRCON_PORT="$(grep '^rcon.port=' "$MINECRAFT_DIR/server.properties" | cut -d'=' -f 2-)"
export MCRCON_PASS="$(grep '^rcon.password=' "$MINECRAFT_DIR/server.properties" | cut -d'=' -f 2-)"

exec /opt/mcrcon "$@"

