DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null && pwd)"
export ROOT_DIR=$DIR/..
export TEST_LIQUIBASE=$DIR/liquibase

# all run
bats $DIR/liquibase/*.bats

# step-by-step
# bats $DIR/liquibase/auto-install.bats
# bats $DIR/liquibase/auto-install-oracle.bats
# bats $DIR/liquibase/auto-install-postgres.bats
# bats $DIR/liquibase/before-liquibase.bats
# bats $DIR/liquibase/pure-liquibase.bats
# bats $DIR/liquibase/pure-liquibase-postgres.bats
