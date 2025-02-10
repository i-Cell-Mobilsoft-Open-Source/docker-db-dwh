#!/usr/bin/env bats

source .env

@test "AUTO_INSTALL with mounted before-liquibase.sh" {
  run docker run --rm \
    -e AUTO_INSTALL=postgresql \
    -e INSTALL_HOST=batstest \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    -v $TEST_LIQUIBASE/before-liquibase.sh:/home/icellmobilsoft/liquibase/bash/before-liquibase.sh \
    icellmobilsoft/db-base-liquibase:$VERSION

#  echo ${status} >&3
#  echo ${output} >&3
  [ "${status}" -eq 1 ]
  expected=">>>> Running script before Liquibase ------------------------------------
SCHEMA_NAME=develop
<<<< Running script before Liquibase ------------------------------------"
  [[ "${output}" =~ "$expected" ]]
}
