#!/usr/bin/env bash

download_sponge() {
  local sponge_repo_url='https://repo-new.spongepowered.org/service/rest/v1/search/assets/download'
  curl -s -L -o "${SPONGE_JAR}" "${sponge_repo_url}?sort=version&repository=maven-releases&maven.groupId=org.spongepowered&maven.artifactId=spongevanilla&maven.extension=jar&maven.classifier=universal&maven.baseVersion=${SPONGE_VERSION}-*"
}

download_sponge
