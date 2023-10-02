#!/bin/bash

minecraft_versions=(
    1.20.2
    1.20.1
    1.19.4
    1.19.3
    1.19.2
    1.18.2
    1.17.1
    1.16.5
)

api_versions=(
    11
    10
    9
    8
)

fetch_versions() {
    local kind="${1?no kind!}"
    shift 1
    for v in "$@"
    do
        curl -s "https://dl-api.spongepowered.org/v2/groups/org.spongepowered/artifacts/spongevanilla/versions?tags=${kind}:${v}&offset=0&limit=1" \
            | jq --arg version "$v" -Mc '{key: $version, value: .artifacts | to_entries | first | .key}'
    done
}

transform_to_versions() {
    jq -s 'sort_by(.key) | from_entries'
}

versions_file="$(mktemp)"

minecraft_versions_file="minecraft-versions.json"
api_versions_file="api-versions.json"

fetch_versions "minecraft" "${minecraft_versions[@]}" | transform_to_versions > "$minecraft_versions_file"
fetch_versions "api" "${api_versions[@]}" | transform_to_versions > "$api_versions_file"

git config user.name 'CubeEngine Sponge Updater'
git config user.email 'no-reply@cubeengine.org'

git add "$minecraft_versions_file" "$api_versions_file"



if ! git commit -m 'My hands are typing words....'
then
    echo "No new versions!"
fi

