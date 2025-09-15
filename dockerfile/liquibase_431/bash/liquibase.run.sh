#!/bin/bash
set -e

# it's OK if the file is not there, and for POSIX shells, failures to open (or parse) the file are reported but are not fatal
[ ! -e "$DEFAULT_PROPERTIES" ] || command source "$DEFAULT_PROPERTIES"

echo "Running Liquibase script (liquibase.run.sh) with parameters..."
URL=${INSTALL_URL:-$(echo ${URL:-"jdbc:postgresql://localhost:5432/postgres"})}
echo "INSTALL_URL=$URL"
USERNAME=${INSTALL_USERNAME:-$(echo ${USERNAME:-postgres})}
echo "INSTALL_USERNAME=$USERNAME"
PASSWORD=${INSTALL_PASSWORD:-$(echo ${PASSWORD:-postgres})}
echo "INSTALL_PASSWORD=***"
CHANGELOGFILE=${INSTALL_CHANGELOGFILE:-$(echo ${CHANGELOGFILE:-liquibase-install-default.xml})}
echo "INSTALL_CHANGELOGFILE=$CHANGELOGFILE"
CONTEXTS=${INSTALL_CONTEXTS:-$(echo ${CONTEXTS:-})}
echo "INSTALL_CONTEXTS=$CONTEXTS"
LABELS=${INSTALL_LABELS:-$(echo ${LABELS:-})}
echo "INSTALL_LABELS=$LABELS"


liquibase \
  --defaultsFile=$HOME/liquibase/liquibase.docker.properties \
  --url=$URL \
  --username=$USERNAME \
  --password=$PASSWORD \
  --changeLogFile=$CHANGELOGFILE \
  --contexts=$CONTEXTS \
  --labels=$LABELS \
  update
