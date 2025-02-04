#!/usr/bin/env bats

source .env

@test "AUTO_INSTALL [ oracle ] with INSTALL_URL, INSTALL_USERNAME_S1, INSTALL_PASSWORD_S1 env" {
  cat $ROOT_DIR/dockerfile/liquibase/bash/liquibase.run.sh |
    tr '\n' '\f' |
    sed -r -e 's/set -e\f/set -ex\f/g' -e 's/(liquibase.*update)/\1 || echo ":::TESTING:::"/g' |
    tr '\f' '\n' > mocked.liquibase.run.sh
  chmod +x mocked.liquibase.run.sh

  run \
    docker run --rm \
    -e AUTO_INSTALL=oracle \
    -e INSTALL_URL=jdbc:oracle:thin:@//test-me:1521/kiskutya \
    -e INSTALL_USERNAME_S1=SYSTEM \
    -e INSTALL_PASSWORD_S1=KISCICA \
    -v $(pwd)/mocked.liquibase.run.sh:/home/icellmobilsoft/liquibase/bash/liquibase.run.sh \
    icellmobilsoft/db-dwh/liquibase:$VERSION

  echo "expected status: 0 [${status}]"
  [ "${status}" -eq 0 ]
  expected_0="liquibase --defaultsFile=/home/icellmobilsoft/liquibase/liquibase.docker.properties --url=jdbc:oracle:thin:@//test-me:1521/kiskutya --username=SYSTEM --password=KISCICA --changeLogFile=liquibase-install-default.xml --contexts= --labels= update"
  expected_1="Connection could not be created to jdbc:oracle:thin:@//test-me:1521/kiskutya with driver oracle.jdbc.OracleDriver."
  echo "output:[$output]"
  echo "expected:[$expected_0]"
  [[ "${output}" =~ "$expected_0" ]]
  echo "expected:[$expected_1]"
  [[ "${output}" =~ "$expected_1" ]]
  echo "expected:[:::TESTING:::]"
  [[ "${output}" =~ ":::TESTING:::" ]]
}

@test "AUTO_INSTALL [ oracle ] with INSTALL_URL, INSTALL_PASSWORD, INSTALL_USERNAME_S2, INSTALL_PASSWORD_S2, MULTI_STEP env" {
  cat $ROOT_DIR/dockerfile/liquibase/bash/liquibase.run.sh |
    tr '\n' '\f' |
    sed -r -e 's/set -e\f/set -ex\f/g' -e 's/(liquibase.*update)/\1 || echo ":::TESTING:::"/g' |
    tr '\f' '\n' > mocked.liquibase.run.sh
  chmod +x mocked.liquibase.run.sh

  run \
    docker run --rm \
    -e AUTO_INSTALL=oracle \
    -e INSTALL_URL=jdbc:oracle:thin:@//test-me:1521/kiskutya \
    -e INSTALL_PASSWORD=PEPEFEFE \
    -e INSTALL_USERNAME_S2=SYSTEM \
    -e INSTALL_PASSWORD_S2=KISCICA \
    -v $(pwd)/mocked.liquibase.run.sh:/home/icellmobilsoft/liquibase/bash/liquibase.run.sh \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/oracle/defaults-step-01.properties \
    -v $TEST_LIQUIBASE/liquibase-defaults.properties:/home/icellmobilsoft/liquibase/oracle/defaults-step-02.properties \
    icellmobilsoft/db-dwh/liquibase:$VERSION
  # set +x
  echo "expected status: 0 [${status}]"
  [ "${status}" -eq 0 ]
  expected_0="liquibase --defaultsFile=/home/icellmobilsoft/liquibase/liquibase.docker.properties --url=jdbc:oracle:thin:@//test-me:1521/kiskutya --username=postgres --password=PEPEFEFE --changeLogFile=liquibase-install-default.xml --contexts=testcontext --labels= update"
  expected_1="liquibase --defaultsFile=/home/icellmobilsoft/liquibase/liquibase.docker.properties --url=jdbc:oracle:thin:@//test-me:1521/kiskutya --username=SYSTEM --password=KISCICA --changeLogFile=liquibase-install-default.xml --contexts=testcontext --labels= update"
  expected_2="Connection could not be created to jdbc:oracle:thin:@//test-me:1521/kiskutya with driver oracle.jdbc.OracleDriver."
  echo "output:[$output]"
  echo "expected:[$expected_0]"
  [[ "${output}" =~ "$expected_0" ]]
  echo "expected:[$expected_1]"
  [[ "${output}" =~ "$expected_1" ]]
  echo "expected:[$expected_2]"
  [[ "${output}" =~ "$expected_2" ]]
  echo "expected:[:::TESTING:::]"
  [[ "${output}" =~ ":::TESTING:::" ]]
}
