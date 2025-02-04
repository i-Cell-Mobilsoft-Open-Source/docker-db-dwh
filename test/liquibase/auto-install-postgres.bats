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

@test "AUTO_INSTALL on postgres with defaults" {
  run \
    docker run --rm --network="host" \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-02.properties \
    -v $TEST_LIQUIBASE/liquibase-changelog.xml:/home/icellmobilsoft/liquibase/changelog/liquibase-install-default.xml \
    -e AUTO_INSTALL=postgresql \
   icellmobilsoft/db-dwh/liquibase:$VERSION

  echo "expected status: 0 [${status}]"
  [ "${status}" -eq 0 ]
  # STEP 1 check
  expected="UPDATE SUMMARY
Run:                          1
Previously run:               0
Filtered out:                 0
-------------------------------
Total change sets:            1

Liquibase: Update has been successful.
Liquibase command 'update' was executed successfully."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
  # STEP 2 check
  expected="UPDATE SUMMARY
Run:                          0
Previously run:               1
Filtered out:                 0
-------------------------------
Total change sets:            1

Liquibase command 'update' was executed successfully."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "AUTO_INSTALL STEP_1 only on postgres with defaults" {
  run \
    docker run --rm --network="host" \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-02.properties \
    -v $TEST_LIQUIBASE/liquibase-changelog.xml:/home/icellmobilsoft/liquibase/changelog/liquibase-install-default.xml \
    -e AUTO_INSTALL=postgresql \
    -e INSTALL_STEP=STEP_1 \
   icellmobilsoft/db-dwh/liquibase:$VERSION

  echo "expected status: 0 [${status}]"
  [ "${status}" -eq 0 ]

  expected=">>>> STEP 1 -------------------------------------------------------------"
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]

  expected="UPDATE SUMMARY
Run:                          1
Previously run:               0
Filtered out:                 0
-------------------------------
Total change sets:            1

Liquibase: Update has been successful.
Liquibase command 'update' was executed successfully."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "AUTO_INSTALL STEP_2 only on postgres with defaults" {
  run \
    docker run --rm --network="host" \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-02.properties \
    -v $TEST_LIQUIBASE/liquibase-changelog.xml:/home/icellmobilsoft/liquibase/changelog/liquibase-install-default.xml \
    -e AUTO_INSTALL=postgresql \
    -e INSTALL_STEP=STEP_2 \
   icellmobilsoft/db-dwh/liquibase:$VERSION

  echo "expected status: 0 [${status}]"
  [ "${status}" -eq 0 ]

  expected=">>>> STEP 2 -------------------------------------------------------------"
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]

  expected="UPDATE SUMMARY
Run:                          1
Previously run:               0
Filtered out:                 0
-------------------------------
Total change sets:            1

Liquibase: Update has been successful.
Liquibase command 'update' was executed successfully."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}
