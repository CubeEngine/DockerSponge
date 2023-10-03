#!/usr/bin/env bash

set -euo pipefail

api_versions=(
    11
    10
    9
    8
)

fetch_versions() {
    local kind="${1?no kind!}"
    local recommended="${2?no recommended flag!}"
    shift 2
    for v in "$@"
    do
        curl -s "https://dl-api.spongepowered.org/v2/groups/org.spongepowered/artifacts/spongevanilla/versions?tags=${kind}:${v}&recommended=${recommended}&offset=0&limit=1" \
            | jq --arg version "$v" -Mc '{key: $version, value: (.artifacts // {}) | to_entries | first | .key}'
    done
}

transform_to_versions() {
    jq -s 'sort_by(.key) | map(select(.value != null)) | from_entries'
}

versions_file="$(mktemp)"

latest_versions_file="latest-versions.json"
recommended_versions_file="recommended-versions.json"

fetch_versions "api" false "${api_versions[@]}" | transform_to_versions > "$latest_versions_file"
fetch_versions "api" true "${api_versions[@]}" | transform_to_versions > "$recommended_versions_file"

git config user.name 'CubeEngine Sponge Updater'
git config user.email 'no-reply@cubeengine.org'

git add "$latest_versions_file" "$recommended_versions_file"

if git commit -m 'My hands are typing words....'
then
    git push
else
    echo "No new versions!"
fi

