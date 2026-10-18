image := "ghcr.io/renovatebot/renovate:44"
repo := "vs-reader/renovate-demo"

export SOPS_AGE_KEY_FILE := env_var_or_default("SOPS_AGE_KEY_FILE", env_var("HOME") + "/.config/sops/age/course.agekey")

default:
    @just --list

validate:
    docker run --rm -v "{{justfile_directory()}}/renovate.json:/usr/src/app/renovate.json:ro" {{image}} renovate-config-validator

dry-run:
    RENOVATE_TOKEN="$(sops decrypt --extract '["git-token"]' config/keys.yml)" \
    docker run --rm -e RENOVATE_TOKEN -e RENOVATE_PLATFORM=github -e RENOVATE_REPOSITORIES={{repo}} -e LOG_LEVEL=info {{image}} --dry-run=full

run:
    RENOVATE_TOKEN="$(sops decrypt --extract '["git-token"]' config/keys.yml)" \
    docker run --rm -e RENOVATE_TOKEN -e RENOVATE_PLATFORM=github -e RENOVATE_REPOSITORIES={{repo}} -e LOG_LEVEL=info {{image}}