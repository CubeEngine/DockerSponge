#!/usr/bin/env bash

build_image() {
    local kind="${1?no kind}"
    local version="${2?no version}"
    local asset="${3?no asset}"

    local repo_name="ghcr.io/cubeengine/sponge"
    local cache_repo="${repo_name}/cache"
    local image_name="${repo_name}:latest"
    podman build -t "$image_name" --layers --cache-from="$cache_repo" --cache-to="$cache_repo" --timestamp 0 .

    local tags=("$kind-$version" "$kind-$asset"
    for t in "${tags}"
    do
        local name="$repo_name:$t"
        podman tag "$image_name" "$name"
        podman push "$name"
    done
}

build_images() {
    local kind="${1?no kind}"


}

build_images minecraft
build_images api
