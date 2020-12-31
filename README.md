# Minecraft SpongeVanilla Docker Image

- [Available on Docker-Hub](https://hub.docker.com/r/cubeengine/sponge/)
- [Available on GitHub](https://github.com/CubeEngine/DockerSponge)

The docker image `cubeengine/sponge` sets up a sponge vanilla minecraft server containing [Sponge Vanilla](https://www.spongepowered.org/) 

This documentation only describes how to set up the docker container. Have a look at the related GitHub projects to get more details about the actual functionality: 

- [Sponge](https://github.com/SpongePowered/Sponge)
- [SpongeAPI](https://github.com/SpongePowered/SpongeAPI)

## Volumes

To persist the data you must mount a few volumes which are listed below:

- `/home/minecraft/root` - This directory only contains the files `banned-ips.json`, `banned-players.json`, `ops.json` and `whitelist.json` of the server root directory.
- `/home/minecraft/world` - This directory stores the heart of the server - the minecraft world(s).
- `/home/minecraft/config` - Here are the configuration files. You might edit them to set up your server correctly.
- `/home/minecraft/logs` - This directory contains the server logs.
- `/home/minecraft/mods` - This directory is your space to store any additional sponge mods.

## Environment Variables

The container can be configured using environment variables.

One important mention is the `JAVA_VM_ARGS` environment variable. This helps you to specify additional arguments for the java process. By default, it doesn't contain anything. As a suggestion I advise you to set the Xmx variable, the maximum size of the memory allocation pool at least 2G or 3G. For this just write `JAVA_VM_ARGS=-Xmx2G`

### Server Properties

You might have noticed that the root-volume doesn't contain the `server.properties` file. This file doesn't need to be persisted because it can be set up using environment variables. Below you'll find a list of the environment variable names. A description of them, supported values and default behaviours can be found on the [minecraft gamepedia site](http://minecraft.gamepedia.com/Server.properties).

 - ALLOW_FLIGHT
 - ALLOW_NETHER
 - BROADCAST_CONSOLE_TO_OPS
 - BROADCAST_RCON_TO_OPS
 - DIFFICULTY
 - ENABLE_COMMAND_BLOCK
 - ENABLE_JMX_MONITORING
 - ENABLE_QUERY
 - ENABLE_RCON
 - ENABLE_STATUS
 - ENFORCE_WHITELIST
 - ENTITY_BROADCAST_RANGE_PERCENTAGE
 - FORCE_GAMEMODE
 - FUNCTION_PERMISSION_LEVEL
 - GAMEMODE
 - GENERATE_STRUCTURES
 - GENERATOR_SETTINGS
 - HARDCORE
 - LEVEL_NAME
 - LEVEL_SEED
 - LEVEL_TYPE
 - MAX_BUILD_HEIGHT
 - MAX_PLAYERS
 - MAX_TICK_TIME
 - MAX_WORLD_SIZE
 - MOTD
 - NETWORK_COMPRESSION_THRESHOLD
 - ONLINE_MODE
 - OP_PERMISSION_LEVEL
 - PLAYER_IDLE_TIMEOUT
 - PREVENT_PROXY_CONNECTIONS
 - PVP
 - QUERY_PORT
 - RATE_LIMIT
 - RCON_PASSWORD
 - RCON_PORT
 - RESOURCE_PACK_SHA1
 - RESOURCE_PACK
 - SERVER_IP
 - SERVER_PORT
 - SNOOPER_ENABLED
 - SPAWN_ANIMALS
 - SPAWN_MONSTERS
 - SPAWN_NPCS
 - SPAWN_PROTECTION
 - SYNC_CHUNK_WRITES
 - TEXT_FILTERING_CONFIG
 - USE_NATIVE_TRANSPORT
 - VIEW_DISTANCE
 - WHITE_LIST

### Database

Some of the Sponge plugins may need a database connection. The database can be set up with the following variables. The list also shows the default values.

- `DB_ALIAS="jdbc:postgresql://user:password@localhost:5432/minecraft"` - The alias under which the following connection string is placed in the sponge.conf
- `DB_CONNECTION_STRING="database` - A connection string to a sql database.

### Ops

When setting up your server initially you might want to give op to a list of players.
Set the environment variable `OPS` to a space separated list of usernames to op them.
This only works for the initial creation.