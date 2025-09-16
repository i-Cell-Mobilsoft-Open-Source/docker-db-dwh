#!/bin/bash
set -e

if [[ ! -z "$AUTO_INSTALL" && -f $LIQUIBASE_HOME/bash/auto.install.sh ]]; then

$LIQUIBASE_HOME/bash/auto.install.sh

else

  # The original docker-entrypoint.sh exists, but in this image there is no 'lpm'
  #if [[ "$INSTALL_MYSQL" ]]; then
  #  lpm add mysql --global
  #fi
  if type "$1" > /dev/null 2>&1; then    
    ## First argument is an actual OS command. Run it
    exec "$@"
  else
    if [[ "$*" == *--defaultsFile* ]] || [[ "$*" == *--defaults-file* ]] || [[ "$*" == *--version* ]]; then
      ## Just run as-is
      liquibase "$@"
    else
      ## Include standard defaultsFile
      liquibase "--defaultsFile=$HOME/liquibase/liquibase.docker.properties" "$@"
    fi
  fi

fi
