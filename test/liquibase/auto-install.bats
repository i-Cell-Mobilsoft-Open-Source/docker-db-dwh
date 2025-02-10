#!/usr/bin/env bats

source .env

@test "AUTO_INSTALL without defaults-step-01.properties file" {
  run docker run --rm -e AUTO_INSTALL=postgresql icellmobilsoft/db-base-liquibase:$VERSION

  echo "expected status: 1 [${status}]"
  [ "${status}" -eq 1 ]
  # echo ${output} >&3
  expected="INSTALL_URL=jdbc:postgresql://localhost:5432/postgres
INSTALL_USERNAME=postgres
INSTALL_PASSWORD=***
INSTALL_CHANGELOGFILE=liquibase-install-default.xml
INSTALL_CONTEXTS=
INSTALL_LABELS="
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "AUTO_INSTALL with defaults" {
    run \
    docker run --rm \
    -e AUTO_INSTALL=postgresql \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    icellmobilsoft/db-base-liquibase:$VERSION

  echo "expected status: 1 [${status}]"
  [ "${status}" -eq 1 ]
  # echo ${output} >&3
  expected="INSTALL_URL=jdbc:postgresql://localhost:5432/postgres
INSTALL_USERNAME=postgres
INSTALL_PASSWORD=***
INSTALL_CHANGELOGFILE=liquibase-install-default.xml
INSTALL_CONTEXTS=testcontext
INSTALL_LABELS="
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "AUTO_INSTALL with INSTALL_URL env" {
  run \
    docker run --rm \
    -e AUTO_INSTALL=postgresql \
    -e INSTALL_URL=jdbc:postgresql://install-url:5432/postgres \
    -v $TEST_LIQUIBASE//liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    icellmobilsoft/db-base-liquibase:$VERSION

  echo "expected status: 1 [${status}]"
  [ "${status}" -eq 1 ]
  # echo ${output} >&3
  expected="Connection could not be created to jdbc:postgresql://install-url:5432/postgres with driver org.postgresql.Driver."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "AUTO_INSTALL with INSTALL_URL and INSTALL_URL_S1 env" {
  run \
    docker run --rm \
    -e AUTO_INSTALL=postgresql \
    -e INSTALL_URL=jdbc:postgresql://install-url:5432/postgres \
    -e INSTALL_URL_S1=jdbc:postgresql://install-url-s1:5432/postgres \
    -v $TEST_LIQUIBASE//liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    icellmobilsoft/db-base-liquibase:$VERSION

  echo "expected status: 1 [${status}]"
  [ "${status}" -eq 1 ]
  # echo ${output} >&3
  expected="Connection could not be created to jdbc:postgresql://install-url-s1:5432/postgres with driver org.postgresql.Driver."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "AUTO_INSTALL with INSTALL_URL_S1 env" {
  run \
    docker run --rm \
    -e AUTO_INSTALL=postgresql \
    -e INSTALL_URL_S1=jdbc:postgresql://install-url-s1:5432/postgres \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    icellmobilsoft/db-base-liquibase:$VERSION

  echo "expected status: 1 [${status}]"
  [ "${status}" -eq 1 ]
  # echo ${output} >&3
  expected="Connection could not be created to jdbc:postgresql://install-url-s1:5432/postgres with driver org.postgresql.Driver."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "AUTO_INSTALL with URL env" {
  run \
    docker run --rm \
    -e AUTO_INSTALL=postgresql \
    -e URL=jdbc:postgresql://url:5432/postgres \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    icellmobilsoft/db-base-liquibase:$VERSION

  echo "expected status: 1 [${status}]"
  [ "${status}" -eq 1 ]
  # echo ${output} >&3
  expected="Connection could not be created to jdbc:postgresql://url:5432/postgres with driver org.postgresql.Driver."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "AUTO_INSTALL with URL, INSTALL_URL and INSTALL_URL_S1 env" {
  run \
    docker run --rm \
    -e AUTO_INSTALL=postgresql \
    -e URL=jdbc:postgresql://url:5432/postgres \
    -e INSTALL_URL=jdbc:postgresql://install-url:5432/postgres \
    -e INSTALL_URL_S1=jdbc:postgresql://install-url-s1:5432/postgres \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    icellmobilsoft/db-base-liquibase:$VERSION

  echo "expected status: 1 [${status}]"
  [ "${status}" -eq 1 ]
  # echo ${output} >&3
  expected="Connection could not be created to jdbc:postgresql://install-url-s1:5432/postgres with driver org.postgresql.Driver."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}

@test "AUTO_INSTALL with URL, INSTALL_URL, INSTALL_URL_S1 and LIQUIBASE_COMMAND_URL env" {
  run \
    docker run --rm \
    -e AUTO_INSTALL=postgresql \
    -e URL=jdbc:postgresql://url:5432/postgres \
    -e INSTALL_URL=jdbc:postgresql://install-url:5432/postgres \
    -e INSTALL_URL_S1=jdbc:postgresql://install-url-s1:5432/postgres \
    -e LIQUIBASE_COMMAND_URL=jdbc:postgresql://liquibase-command-url-s1:5432/postgres \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/postgresql/defaults-step-01.properties \
    icellmobilsoft/db-base-liquibase:$VERSION

  echo "expected status: 1 [${status}]"
  [ "${status}" -eq 1 ]
  expected="Connection could not be created to jdbc:postgresql://install-url-s1:5432/postgres with driver org.postgresql.Driver."
  echo "expected:[$expected]"
  echo "output:[$output]"
  [[ "${output}" =~ "$expected" ]]
}
