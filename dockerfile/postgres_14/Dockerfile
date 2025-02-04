#postgres:14.8-bullseye
ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS pg_cron_base

# Install required packages
# the lsb-release package: is needed to determine the correct codename for the distribution.
RUN apt-get update && apt-get install -y wget ca-certificates gnupg2 lsb-release \
    # Add PostgreSQL repository key
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \  
    # Add PostgreSQL repository
    # the tee command is used to write the repository information to the pgdg.list file.
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    # Install PG Cron extension
    && apt-get update && apt-get install -y postgresql-14-cron \
    # Cleanup
   && apt-get clean && rm -rf /var/lib/apt/lists/*

#We need to copy the pg-cron.sh to docker-entrypoint-initdb.d folder b/c the image runs all file in this folder.
#pg-cron.sh: it adds cron.database_name and shared_preload_libraries = 'pg_cron' to postgresql.conf
COPY ./dockerfile/postgres_14/pg-cron.sh ./docker-entrypoint-initdb.d

#set the execution access to pg-cron.sh so that the image runs this file
RUN chmod +x ./docker-entrypoint-initdb.d/pg-cron.sh

USER postgres
