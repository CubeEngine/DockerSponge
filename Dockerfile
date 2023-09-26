ARG JAVA_BASE_IMAGE=eclipse-temurin:17-jdk-alpine

FROM alpine:3.15 AS mcrcon

ARG MCRCON_VERSION="0.7.2"

RUN apk add --update git gcc musl-dev make
RUN cd /tmp \
 && git clone -b "v${MCRCON_VERSION}" --depth=1 https://github.com/Tiiffi/mcrcon . \
 && make \
 && mv mcrcon /

FROM $JAVA_BASE_IMAGE

ARG SPONGE_VERSION="1.16.5-8.2.0"
# "rc" or "release"
ARG SPONGE_TYPE="rc"
ENV MINECRAFT_DIR="/minecraft"

RUN adduser -D -h "${MINECRAFT_DIR}" "minecraft"

ENV SPONGE_JAR="${MINECRAFT_DIR}/sponge.jar" \
	MINECRAFT_MODS_DIR="${MINECRAFT_DIR}/mods" \
	MINECRAFT_PLUGINS_DIR="${MINECRAFT_DIR}/plugins" \
	MINECRAFT_CONFIG_DIR="${MINECRAFT_DIR}/config" \
	MINECRAFT_WORLD_DIR="${MINECRAFT_DIR}/world" \
	MINECRAFT_LOGS_DIR="${MINECRAFT_DIR}/logs" \
	MINECRAFT_ROOT_STUFF_DIR="${MINECRAFT_DIR}/root"

# bash: easy scripting
# curl: sponge download and nice to have
# gettext: envsubst
RUN apk add --update --no-cache curl bash gettext

RUN curl -s -L -o "/sponge.jar" "https://repo.spongepowered.org/service/rest/v1/search/assets/download?sort=version&repository=maven-releases&maven.groupId=org.spongepowered&maven.artifactId=spongevanilla&maven.extension=jar&maven.classifier=universal&maven.baseVersion=${SPONGE_VERSION}"

COPY --from=mcrcon /mcrcon /opt/mcrcon
COPY mcrcon.sh /usr/local/bin/mcrcon

COPY log4j2.xml /
COPY launcher.conf.template /

USER "minecraft:minecraft"

WORKDIR ${MINECRAFT_DIR}
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["--nogui"]

EXPOSE 25565/tcp 25575/tcp

VOLUME ["${MINECRAFT_DIR}"]

ENV JVM_ARGS=""
ENV LAUNCHER_JVM_ARGS=""

ENV DB_CONNECTION_STRING="jdbc:postgresql://user:password@localhost:5432/minecraft" \
    DB_ALIAS="database"

ENV OPS=""

# The next env variables control the server.properties file. Have a look at the documentation of the file to get the meaning.
ENV	ALLOW_FLIGHT=false \
    ALLOW_NETHER=true \
    BROADCAST_CONSOLE_TO_OPS=true \
    BROADCAST_RCON_TO_OPS=true \
    DIFFICULTY=easy \
    ENABLE_COMMAND_BLOCK=false \
    ENABLE_JMX_MONITORING=false \
    ENABLE_QUERY=false \
    ENABLE_RCON=false \
    ENABLE_STATUS=true \
    ENFORCE_WHITELIST=false \
    ENTITY_BROADCAST_RANGE_PERCENTAGE=100 \
    FORCE_GAMEMODE=false \
    FUNCTION_PERMISSION_LEVEL=2 \
    GAMEMODE=survival \
    GENERATE_STRUCTURES=true \
    GENERATOR_SETTINGS="" \
    HARDCORE=false \
    LEVEL_NAME=world \
    LEVEL_SEED="" \
    LEVEL_TYPE=default \
    MAX_BUILD_HEIGHT=256 \
    MAX_PLAYERS=20 \
    MAX_TICK_TIME=60000 \
    MAX_WORLD_SIZE=29999984 \
    MOTD="A Minecraft Server" \
    NETWORK_COMPRESSION_THRESHOLD=256 \
    ONLINE_MODE=true \
    OP_PERMISSION_LEVEL=4 \
    PLAYER_IDLE_TIMEOUT=0 \
    PREVENT_PROXY_CONNECTIONS=false \
    PVP=true \
    QUERY_PORT=25565 \
    RATE_LIMIT=0 \
    RCON_PASSWORD="" \
    RCON_PORT=25575 \
    RESOURCE_PACK_SHA1="" \
    RESOURCE_PACK="" \
    SERVER_IP="" \
    SERVER_PORT=25565 \
    SNOOPER_ENABLED=true \
    SPAWN_ANIMALS=true \
    SPAWN_MONSTERS=true \
    SPAWN_NPCS=true \
    SPAWN_PROTECTION=16 \
    SYNC_CHUNK_WRITES=true \
    TEXT_FILTERING_CONFIG="" \
    USE_NATIVE_TRANSPORT=true \
    VIEW_DISTANCE=10 \
    WHITE_LIST=false

