#!/usr/bin/env bats

source .env

setup() {
  docker run --rm -d \
    -p 5432:5432 \
    --name docker-db-dwh-postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_USER=postgres \
    icellmobilsoft/db-dwh/postgres:$VERSION
}

teardown() {
    docker stop docker-db-dwh-postgres
}

@test "Liquibase with not parseable changelog" {
  run \
    docker run --rm --network="host" \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/liquibase-defaults.properties \
    icellmobilsoft/db-dwh/liquibase:$VERSION \
    update \
      --changelog-file=/home/icellmobilsoft/liquibase/postgresql/liquibase-defaults.properties \
      --url='jdbc:postgresql://localhost:5432/postgres' \
      --username=postgres \
      --password=postgres

  echo "expected status: 1 [${status}]"
  [ "${status}" -eq 1 ]
  expected="Unexpected error running Liquibase: Cannot find parser that supports /home/icellmobilsoft/liquibase/postgresql/liquibase-defaults.properties"
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "Liquibase with changelog" {
  run \
    docker run --rm --network="host" \
    -v $TEST_LIQUIBASE/liquibase-changelog.xml:/home/icellmobilsoft/liquibase/changelog/liquibase-changelog.xml \
    icellmobilsoft/db-dwh/liquibase:$VERSION \
    update \
      --changelog-file=liquibase-changelog.xml \
      --url='jdbc:postgresql://localhost:5432/postgres' \
      --username=postgres \
      --password=postgres

  echo "expected status: 0 [${status}]"
  [ "${status}" -eq 0 ]
  expected="Liquibase: Update has been successful.
Liquibase command 'update' was executed successfully."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}


#    -e LIQUIBASE_COMMAND_LABELS=no-file \
