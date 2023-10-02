#!/usr/bin/env bash

set -euo pipefail

build_image() {
    local kind="${1?no kind}"
    local version="${2?no version}"
    local asset="${3?no asset}"

    local sponge_jar_file="sponge.jar"
    local download_url="$(curl -s "https://dl-api.spongepowered.org/v2/groups/org.spongepowered/artifacts/spongevanilla/versions/$asset" | jq -r '.assets | map(select(.classifier == "universal")) | first | .downloadUrl')"
    curl -s -L -o "$sponge_jar_file" "$download_url"

    local repo_name="ghcr.io/cubeengine/sponge"
    local cache_repo="${repo_name}/cache"
    local image_name="${repo_name}:latest"
    podman build \
        -t "$image_name" \
        --layers \
        --timestamp 0 \
        .
    rm "$sponge_jar_file"

    local tags=("$kind-$version" "$kind-$asset")
    for t in "${tags[@]}"
    do
        local name="$repo_name:$t"
        podman tag "$image_name" "$name"
        podman push "$name"
    done
}

build_images() {
    local kind="${1?no kind}"

    local file="$kind-versions.json"

    readarray -t versions <<< "$(jq -r 'to_entries | map(.key) | .[]' < $file)"
    for version in "${versions[@]}"
    do
        local asset="$(jq -r --arg version "$version" '.[$version]' < $file)"
        build_image "$kind" "$version" "$asset"
    done
}

build_images minecraft
build_images api
