#!/bin/bash
set -e

if [[ -f $LIQUIBASE_HOME/bash/before-liquibase.sh ]]; then

  echo ">>>> Running script before Liquibase ------------------------------------"
  source $LIQUIBASE_HOME/bash/before-liquibase.sh
  echo "<<<< Running script before Liquibase ------------------------------------"

fi

step() {
  echo "-------------------------------------------------------------------------"
  echo ">>>> STEP $1 -------------------------------------------------------------"
  echo "-------------------------------------------------------------------------"
  overrides "INSTALL_URL" $1
  overrides "INSTALL_USERNAME" $1
  # do not echo passwords
  if [ -n "$(eval echo \$INSTALL_PASSWORD_S$1)" ]; then
    echo INSTALL_PASSWORD_S$1=***
    INSTALL_PASSWORD=$(eval echo \$INSTALL_PASSWORD_S$1)
    echo INSTALL_PASSWORD=***
  fi
  overrides "INSTALL_CHANGELOGFILE" $1
  overrides "INSTALL_CONTEXTS" $1
  overrides "INSTALL_LABELS" $1

  # zero padding, for double digit numbers
  INSTALL_PASSWORD=$INSTALL_PASSWORD DEFAULT_PROPERTIES=$LIQUIBASE_HOME/$AUTO_INSTALL/defaults-step-$(printf %02d $1).properties $LIQUIBASE_HOME/bash/liquibase.run.sh
}

# sample usage: "overrides "INSTALL_USERNAME" $1"
overrides() {
  # does the "INSTALL_USERNAME_S1" parameter exists?
  if [ -n "$(eval echo \$$1_S$2)" ]; then
    # write out the value of "INSTALL_USERNAME_S1"
    echo $1_S$2=$(eval echo \$$1_S$2)
    echo The $1_S$2 will overwrite $1 key with \'$(eval echo \$$1_S$2)\' value
    # overwrite "INSTALL_USERNAME" parameter with the value of "INSTALL_USERNAME_S1"
    export "$1=$(eval echo \$$1_S$2)"
    # optical check of value "INSTALL_USERNAME"
    echo $1=$(eval echo \$$1_S$2)
  fi
}

# check the number of files in "AUTO_INSTALL" directory
# this will be the max number of steps, that should be executed
[[ -d "$LIQUIBASE_HOME/$AUTO_INSTALL/" ]] && STEPS=$(ls -1 $LIQUIBASE_HOME/$AUTO_INSTALL/ | grep "defaults-step-.*.properties" | wc -l) || STEPS=1

# run every step, if there is no "INSTALL_STEP" given
if [[ -z "$INSTALL_STEP" ]]; then
  # starting from 1, because properties files start from one
  for (( i=1; i<=$STEPS; i++ ))
  do
    step $i
  done
else
  # else, check for the actual "INSTALL_STEP"
  # and store the value after the underscore
  REQUESTED_STEP=${INSTALL_STEP#*_}
  # if there is no such step, then error
  if [[ ! -f $LIQUIBASE_HOME/$AUTO_INSTALL/defaults-step-$(printf %02d $REQUESTED_STEP).properties ]]; then
    echo "The requested INSTALL_STEP=${INSTALL_STEP} does not exists"
    exit 1
  else
    step $REQUESTED_STEP
  fi
fi
