#!/bin/bash

server_properties="${MINECRAFT_DIR}/server.properties"
sponge_conf="${MINECRAFT_CONFIG_DIR}/sponge/sponge.conf"

#######################################
# Sets a property within the server.properties file of the
# minecraft server.
# Globals:
#   - server_properties
# Arguments:
#   - The property which shall be set.
#	- The value of the property.
# Returns:
#   None
#######################################
set_server_property() {
	local property=$1
	local value=$2

	echo "Sets server property '${property}' to '${value}'."
	echo "${property}=${value}" >> "${server_properties}"
}

#######################################
# Initializes the server properties file.
# Arguments:
#   None
# Returns:
#   None
#######################################
initialize_server_properties() {

  set_server_property "allow-flight" "${ALLOW_FLIGHT}"
  set_server_property "allow-nether" "${ALLOW_NETHER}"
  set_server_property "broadcast-console-to-ops" "${BROADCAST_CONSOLE_TO_OPS}"
  set_server_property "broadcast-rcon-to-ops" "${BROADCAST_RCON_TO_OPS}"
  set_server_property "difficulty" "${DIFFICULTY}"
  set_server_property "enable-command-block" "${ENABLE_COMMAND_BLOCK}"
  set_server_property "enable-jmx-monitoring" "${ENABLE_JMX_MONITORING}"
  set_server_property "enable-query" "${ENABLE_QUERY}"
  set_server_property "enable-rcon" "${ENABLE_RCON}"
  set_server_property "enable-status" "${ENABLE_STATUS}"
  set_server_property "enforce-whitelist" "${ENFORCE_WHITELIST}"
  set_server_property "entity-broadcast-range-percentage" "${ENTITY_BROADCAST_RANGE_PERCENTAGE}"
  set_server_property "force-gamemode" "${FORCE_GAMEMODE}"
  set_server_property "function-permission-level" "${FUNCTION_PERMISSION_LEVEL}"
  set_server_property "gamemode" "${GAMEMODE}"
  set_server_property "generate-structures" "${GENERATE_STRUCTURES}"
  set_server_property "generator-settings" "${GENERATOR_SETTINGS}"
  set_server_property "hardcore" "${HARDCORE}"
  set_server_property "level-name" "${LEVEL_NAME}"
  set_server_property "level-seed" "${LEVEL_SEED}"
  set_server_property "level-type" "${LEVEL_TYPE}"
  set_server_property "max-build-height" "${MAX_BUILD_HEIGHT}"
  set_server_property "max-players" "${MAX_PLAYERS}"
  set_server_property "max-tick-time" "${MAX_TICK_TIME}"
  set_server_property "max-world-size" "${MAX_WORLD_SIZE}"
  set_server_property "motd" "${MOTD}"
  set_server_property "network-compression-threshold" "${NETWORK_COMPRESSION_THRESHOLD}"
  set_server_property "online-mode" "${ONLINE_MODE}"
  set_server_property "op-permission-level" "${OP_PERMISSION_LEVEL}"
  set_server_property "player-idle-timeout" "${PLAYER_IDLE_TIMEOUT}"
  set_server_property "prevent-proxy-connections" "${PREVENT_PROXY_CONNECTIONS}"
  set_server_property "pvp" "${PVP}"
  set_server_property "query.port" "${QUERY_PORT}"
  set_server_property "rate-limit" "${RATE_LIMIT}"
  set_server_property "rcon.password" "${RCON_PASSWORD}"
  set_server_property "rcon.port" "${RCON_PORT}"
  set_server_property "resource-pack-sha1" "${RESOURCE_PACK_SHA1}"
  set_server_property "resource-pack" "${RESOURCE_PACK}"
  set_server_property "server-ip" "${SERVER_IP}"
  set_server_property "server-port" "${SERVER_PORT}"
  set_server_property "snooper-enabled" "${SNOOPER_ENABLED}"
  set_server_property "spawn-animals" "${SPAWN_ANIMALS}"
  set_server_property "spawn-monsters" "${SPAWN_MONSTERS}"
  set_server_property "spawn-npcs" "${SPAWN_NPCS}"
  set_server_property "spawn-protection" "${SPAWN_PROTECTION}"
  set_server_property "sync-chunk-writes" "${SYNC_CHUNK_WRITES}"
  set_server_property "text-filtering-config" "${TEXT_FILTERING_CONFIG}"
  set_server_property "use-native-transport" "${USE_NATIVE_TRANSPORT}"
  set_server_property "view-distance" "${VIEW_DISTANCE}"
  set_server_property "white-list" "${WHITE_LIST}"
}

initialize_database_config() {
  mkdir -p "$(dirname ${sponge_conf})"

  echo "Creates ${sponge_conf} with database db alias"
  local conf=<<EOF
sql {
  aliases {
    ${DB_ALIAS}=${DB_CONNECTION_STRING}
  }
}
include "sponge.local.conf"
EOF
    echo "$conf" > "${sponge_conf}"
}

initialize_ops() {
  if ! [ -e "${MINECRAFT_DIR}/ops.json" ]
  then
    echo "ops.json does not exist, initializing with ops.txt ..."
    local txt="${MINECRAFT_DIR}/ops.txt"
    rm "$txt" 2>/dev/null
    local users=(${OPS})
    for user in "${users[@]}"
    do
      echo "Initial Op: $user"
      echo "$user" >> "$txt"
    done
  fi
}

initialize_server_properties
initialize_database_config
initialize_ops

if [ ! -f "eula.txt" ]; then
    echo "eula=true" > ./eula.txt
fi

echo "-------------------------------"
echo "start the server..."

exec java ${JAVA_VM_ARGS} -jar "${SPONGE_JAR}"
