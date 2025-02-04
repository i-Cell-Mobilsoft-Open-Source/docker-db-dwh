# from docker-compose.yml
ARG LIQUIBASE_BASE_IMAGE

################################################################################
# Default image customization
################################################################################
FROM ${LIQUIBASE_BASE_IMAGE} as base

# Any special modification required on base image can be done here...

################################################################################
# Create production image
################################################################################
FROM base as prod

ARG LIQUIBASE_INSTALL_DIR
ARG LIQUIBASE_PROPERTIES

# DOCKER_LIQUIBASE_CHANGELOG env comes from base image
COPY --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP $LIQUIBASE_PROPERTIES $LIQUIBASE_HOME
COPY --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP $LIQUIBASE_INSTALL_DIR $DOCKER_LIQUIBASE_CHANGELOG
