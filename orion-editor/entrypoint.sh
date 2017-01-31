#!/bin/sh
# Copyright (c) 2017 Codenvy, S.A.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#   James Drummond - Initial Implementation
#
# See: https://sipb.mit.edu/doc/safe-shell/
set -e
set -u

init_usage() {
  USAGE="
USAGE: 
  docker run -it --rm <DOCKER_PARAMETERS> ${ORION_IMAGE_FULLNAME}
MANDATORY DOCKER PARAMETERS:
  -v <LOCAL_PATH>:${CONTAINER_PATH}                Default server linked folder

OPTIONAL DOCKER PARAMETERS:
  -v <LOCAL_CONFIG_FILE>:${CONFIG_FILE}                Optional host specified Orion configuration file
  -v <LOCAL_INI_FILE>:${INI_FILE}                Optional host specified Orion ini file

GLOBAL COMMAND OPTIONS:
  --debug                              Enable debugging
"
}

init_constants() {
  BLUE='\033[1;34m'
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  YELLOW='\033[38;5;220m'
  BOLD='\033[1m'
  UNDERLINE='\033[4m'
  NC='\033[0m'
}

# Sends arguments as a text to CLI log file
# Usage:
#   log <argument> [other arguments]
log() {
  if [[ "$LOG_INITIALIZED"  = "true" ]]; then
    if is_log; then
      echo "$@" >> "${LOGS}"
    fi
  fi
}

usage() {
 # debug $FUNCNAME
  init_usage
  printf "%s" "${USAGE}"
  return 1;
}

warning() {
  if is_warning; then
    printf  "${YELLOW}WARN:${NC} %s\n" "${1}"
  fi
  log $(printf "WARN: %s\n" "${1}")
}

info() {
  if [ -z ${2+x} ]; then
    PRINT_COMMAND=""
    PRINT_STATEMENT=$1
  else
    PRINT_COMMAND="($CHE_MINI_PRODUCT_NAME $1): "
    PRINT_STATEMENT=$2
  fi
  if $is_info; then
    printf "${GREEN}INFO:${NC} %b%b\n" \
              "${PRINT_COMMAND}" \
              "${PRINT_STATEMENT}"
  fi
  log $(printf "INFO: %b %b\n" \
        "${PRINT_COMMAND}" \
        "${PRINT_STATEMENT}")
}

debug() {
  if is_debug; then
    printf  "\n${BLUE}DEBUG:${NC} %s" "${1}"
  fi
  log $(printf "\nDEBUG: %s" "${1}")
}

error() {
  printf  "${RED}ERROR:${NC} %s\n" "${1}"
  log $(printf  "ERROR: %s\n" "${1}")
}

# Prints message without changes
# Usage: has the same syntax as printf command
text() {
  printf "$@"
  log $(printf "$@")
}

init() {
  init_constants
}

start() {
  # Bootstrap networking, docker, logging, and ability to load cli.sh and library.sh
  ORION_IMAGE_FULLNAME='jdrummond/orion-editor'
  CONTAINER_PATH='/home/orion'
  INI_FILE='/usr/local/eclipse/orion.ini'
  CONFIG_FILE='/orion.conf'
  LOG_INITIALIZED='false'
  is_info=true


  init "$@"
  if [ ! -d $CONTAINER_PATH ]; then
    error "Must provide local host folder volume mounted to $CONTAINER_PATH"
    usage
    return -1
  fi
  
  if [ ! -f $CONFIG_FILE ]; then
      ADMIN_PASSWORD=$(pwgen -s -1 14)
      echo "orion.auth.user.creation=admin" >> $CONFIG_FILE
      echo "orion.file.allowedPaths=$CONTAINER_PATH" >> $CONFIG_FILE
      echo "orion.auth.admin.default.password=$ADMIN_PASSWORD" >> $CONFIG_FILE
  fi
  /usr/local/eclipse/orion > /dev/null &
  
  while ! [ -d /serverworkspace/ad/admin ];
  do
    sleep 1
  done
  cp /admin-OrionContent.json /serverworkspace/ad/admin/
  cat > /serverworkspace/ad/admin/host_folder.json <<- EOF
  {
    "ContentLocation": "file:/home/orion/",
    "FullName": "host_folder",
    "OrionVersion": 8,
    "Properties": {},
    "UniqueId": "host_folder",
    "WorkspaceId": "admin-OrionContent"
  }
EOF
  if [ ADMIN_PASSWORD!="" ]; then
      info "Default username=admin password=$ADMIN_PASSWORD"
      ADMIN_PASSWORD=""
  fi
  tail -f /dev/null
}

start




