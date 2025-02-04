#!/usr/bin/env bats

source .env

@test "Liquibase without command" {
  run docker run --rm icellmobilsoft/db-dwh/liquibase:$VERSION

#  echo ${status} >&3
#  echo ${output} >&3
  [ "${status}" -eq 2 ]
  expected="Missing required subcommand
Usage: liquibase [GLOBAL OPTIONS] [COMMAND] [COMMAND OPTIONS]"
  [[ "${output}" =~ "$expected" ]]
}
