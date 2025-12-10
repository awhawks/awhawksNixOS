#!/usr/bin/env bash
#set -x
set -e
set -u
set -o errexit

scriptDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd ${scriptDir} || exit 13

if [ $# -ne 1 ]
then
  echo "usage: $0 <docker-compose.yml filename not path>"
  exit 13
fi

if [ ! -f "${scriptDir}/${1}" ]
then
  echo "compose file does not exist at [${scriptDir}/${1}]"
  exit 13
fi

args=""
#args="${args} -auto_format"                         # if true, Nix output will be formatted using "nixfmt" (must be present in $PATH).
args="${args} -auto_start"                          # auto-start setting for generated service(s). this applies to all services, not just containers. (default true)
#args="${args} -build"                               # if set, generated container build systemd services will be enabled.
#args="${args} -check_bind_mounts"                   # if set, check that bind mount paths exist. this is useful if running the generated Nix code on the same machine.
#args="${args} -check_systemd_mounts"                # if set, volume paths will be checked against systemd mount paths on the current machine and marked as container dependencies.
args="${args} -create_root_target"                  # if set, a root systemd target will be created, which when stopped tears down all resources. (default true)
args="${args} -default_stop_timeout 1m30s"          # default stop timeout for generated container services. (default 1m30s)
#args="${args} -enable_option"                       # generate a NixOS module option. this allows you to enable or disable the generated module from within your NixOS config. by default, the option will be named "options.[project_name]", but you can add a prefix using the "option_prefix" flag.
args="${args} -env_files /run/agenix/gluetun-env"   # one or more comma-separated paths to .env file(s).
#args="${args} -env_files_only"                      # only use env file(s) in the NixOS container definitions.
#args="${args} -generate_unused_resources"           # if set, unused resources (e.g., networks) will be generated even if no containers use them.
args="${args} -ignore_missing_env_files"            # if set, missing env files will be ignored.
args="${args} -include_env_files"                   # include env files in the NixOS container definition.
args="${args} -inputs $1"                           # one or more comma-separated path(s) to Compose file(s). (default "docker-compose.yml")
#args="${args} -option_prefix string"                # Prefix for the option. If empty, the project name will be used as the option name. (e.g. custom.containers)
args="${args} -output myarrstack.nix"               # path to output Nix file. (default "docker-compose.nix")
#args="${args} -project string"                      # project name used as a prefix for generated resources. this overrides any top-level "name" set in the Compose file(s).
#args="${args} -remove_volumes"                      # if set, volumes will be removed on systemd service stop.
#args="${args} -root_path string"                    # absolute path to use as the root for any relative paths in the Compose file (e.g., volumes, env files). defaults to the current working directory.
args="${args} -runtime podman"                      # one of: ["podman", "docker"]. (default "podman")
#args="${args} -service_include string"              # regex pattern for services to include.
#args="${args} -use_compose_log_driver"              # if set, always use the Docker Compose log driver.
args="${args} -use_upheld_by"                       # if set, upheldBy will be used for service dependencies (NixOS 24.05+).
#args="${args} -version"                             # display version and exit
args="${args} -write_nix_setup"                     # if true, Nix setup code is written to output (runtime, DNS, autoprune, etc.) (default true)

nix run github:aksiksi/compose2nix -- ${args}
