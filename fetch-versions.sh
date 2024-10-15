#!/usr/bin/env bash

set -euo pipefail

declare -A api_mc_versions=(
    [12]="1.21.1"
    [11]="1.20.6"
    [10]="1.19.4"
    [9]="1.18.2"
    [8]="1.16.5"
)

fetch_versions() {
    local kind="${1?no kind!}"
    local recommended="${2?no recommended flag!}"

    shift 2
    for api_version in "$@"
    do
        local mc_versions="${api_mc_versions[$api_version]}"
        for mc_version in $mc_versions
        do
          curl -s "https://dl-api.spongepowered.org/v2/groups/org.spongepowered/artifacts/spongevanilla/versions?tags=${kind}:${api_version},minecraft:${mc_version}&recommended=${recommended}&offset=0&limit=1" \
              | jq --arg version "$api_version" -Mc '{key: $version, value: (.artifacts // {}) | to_entries | first | .key}'
        done
    done
}

transform_to_versions() {
    jq -s 'sort_by(.key) | map(select(.value != null)) | from_entries'
}

versions_file="$(mktemp)"

latest_versions_file="latest-versions.json"
recommended_versions_file="recommended-versions.json"

fetch_versions "api" false "${!api_mc_versions[@]}" | transform_to_versions > "$latest_versions_file"
fetch_versions "api" true "${!api_mc_versions[@]}" | transform_to_versions > "$recommended_versions_file"

git config user.name 'CubeEngine Sponge Updater'
git config user.email 'no-reply@cubeengine.org'

commit() {
    local file="${1?no file}"
    local name="${2?no name}"
    git add "$file"
    git commit -m "$name updated"
}

updated=false
if commit "$latest_versions_file" "Latest versions"
then
    updated=true
fi
if commit "$recommended_versions_file" "Recommended versions"
then
    updated=true
fi

if [ "$updated" = "true" ]
then
    git push
    exit 0
else
    echo "No new versions!"
    exit 1
fi

