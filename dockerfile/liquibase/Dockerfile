ARG ARTIFACT_DOWNLOADER_IMAGE
ARG LIQUIBASE_VERSION
ARG BASE_IMAGE
################################################################################
# Stage 1: Download ojdbc*.jar
#   ojdbc download based on: https://gitlab.k8s.icellmobilsoft.hu/common/baseimages/docker-wildfly/-/blob/master/dockerfile/wildfly/oracle-jdbc/Dockerfile#L56
#   Jira: https://icellmobilsoft-int.atlassian.net/browse/DCKDBDWH-8
################################################################################
FROM $ARTIFACT_DOWNLOADER_IMAGE as download

ARG POM_OJDBC_GROUP_ID
ARG POM_OJDBC_ARTIFACT_ID
ARG POM_OJDBC_VERSION
ARG POM_OJDBC_EXTENSION

ENV NEXUS_OBJECT_GROUP_ID=$POM_OJDBC_GROUP_ID
ENV NEXUS_OBJECT_ARTIFACT_ID=$POM_OJDBC_ARTIFACT_ID
ENV NEXUS_OBJECT_VERSION=$POM_OJDBC_VERSION
ENV NEXUS_OBJECT_EXTENSION=$POM_OJDBC_EXTENSION

ENV NEXUS_DOWNLOAD_OUTPUT_FILE_NAME=$NEXUS_OBJECT_ARTIFACT_ID.$NEXUS_OBJECT_EXTENSION
RUN echo "HOME: " $HOME

RUN $HOME/script/maven-search-download.sh

ARG POM_ORAI18N_GROUP_ID
ARG POM_ORAI18N_ARTIFACT_ID
ARG POM_ORAI18N_VERSION
ARG POM_ORAI18N_EXTENSION

ENV NEXUS_OBJECT_GROUP_ID=$POM_ORAI18N_GROUP_ID
ENV NEXUS_OBJECT_ARTIFACT_ID=$POM_ORAI18N_ARTIFACT_ID
ENV NEXUS_OBJECT_VERSION=$POM_ORAI18N_VERSION
ENV NEXUS_OBJECT_EXTENSION=$POM_ORAI18N_EXTENSION

ENV NEXUS_DOWNLOAD_OUTPUT_FILE_NAME=$NEXUS_OBJECT_ARTIFACT_ID.$NEXUS_OBJECT_EXTENSION

RUN $HOME/script/maven-search-download.sh

################################################################################
# Stage 2: Liquibase
################################################################################
FROM dockerhub-dockerio.icellmobilsoft.hu/liquibase/liquibase:$LIQUIBASE_VERSION as liqui

################################################################################
# Stage 3: Base image
################################################################################
FROM ${BASE_IMAGE} as base

ARG LIQUIBASE_HOME_DEFAULT=$HOME/liquibase
ENV LIQUIBASE_HOME=$LIQUIBASE_HOME_DEFAULT

ENV PATH="$LIQUIBASE_HOME:${PATH}"

ARG CHANGELOG_DIR_NAME=changelog
ENV DOCKER_LIQUIBASE_CHANGELOG=$LIQUIBASE_HOME_DEFAULT/$CHANGELOG_DIR_NAME
ARG CLASSPATH_DIR_NAME=classpath
ENV DOCKER_LIQUIBASE_CLASSPATH=$LIQUIBASE_HOME_DEFAULT/$CLASSPATH_DIR_NAME

RUN mkdir $LIQUIBASE_HOME && \
    mkdir $DOCKER_LIQUIBASE_CHANGELOG && \
    mkdir $DOCKER_LIQUIBASE_CLASSPATH

ARG DOWNLOAD_DIR=$HOME/download
################################################################################
# Copy files
################################################################################
# SYSTEM_USER and SYSTEM_USER_GROUP are declared in base image:
#   https://github.com/i-Cell-Mobilsoft-Open-Source/docker-base/blob/main/dockerfile/bases/base/Dockerfile#L7
# copy the ojdbc files into the lib folder
COPY --from=download --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP ${DOWNLOAD_DIR}/ ${LIQUIBASE_HOME}/lib
# --
COPY --from=liqui --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP /liquibase $LIQUIBASE_HOME
COPY --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP dockerfile/liquibase/bash $LIQUIBASE_HOME/bash
COPY --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP dockerfile/liquibase/docker-entrypoint.sh $LIQUIBASE_HOME/docker-entrypoint.sh
COPY --chown=$SYSTEM_USER:$SYSTEM_USER_GROUP dockerfile/liquibase/liquibase.docker.properties $LIQUIBASE_HOME/liquibase.docker.properties

################################################################################
# Finalize the image
################################################################################
LABEL base.image=$BASE_IMAGE
LABEL image.usage=release
LABEL install=liquibase
LABEL liquibase.version=$LIQUIBASE_VERSION
LABEL liquibase.home=$LIQUIBASE_HOME
LABEL liquibase.env=DOCKER_LIQUIBASE_CHANGELOG=$DOCKER_LIQUIBASE_CHANGELOG,DOCKER_LIQUIBASE_CLASSPATH=$DOCKER_LIQUIBASE_CLASSPATH

WORKDIR $LIQUIBASE_HOME
ENTRYPOINT ["./docker-entrypoint.sh"]