#BASE_IMAGE is mapped in docker-compose.yml file's postgres-release part to .env's POSTGRES_BASE_IMAGE
#postgres:16.3-bullseye
ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS pg_cron_base

# Install required packages
# the lsb-release package: is needed to determine the correct codename for the distribution.
RUN apt-get update && apt-get install -y postgresql-16-cron \
    # Cleanup
   && apt-get clean && rm -rf /var/lib/apt/lists/*

#We need to copy the pg-cron.sh to docker-entrypoint-initdb.d folder b/c the image runs all file in this folder.
#pg-cron.sh: it adds cron.database_name and shared_preload_libraries = 'pg_cron' to postgresql.conf
COPY ./dockerfile/postgres_16/pg-cron.sh ./docker-entrypoint-initdb.d

#set the execution access to pg-cron.sh so that the image runs this file
RUN chmod +x ./docker-entrypoint-initdb.d/pg-cron.sh

USER postgres
