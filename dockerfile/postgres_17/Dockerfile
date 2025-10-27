#BASE_IMAGE is mapped in docker-compose.yml file's postgres-release part to .env's POSTGRES_BASE_IMAGE
#postgres:16.3-bullseye
ARG BASE_IMAGE
FROM ${BASE_IMAGE} AS pg_cron_base

# Install required packages
# the lsb-release package: is needed to determine the correct codename for the distribution.
RUN apt-get update && apt-get install -y postgresql-17-cron \
    # Cleanup
   && apt-get clean && rm -rf /var/lib/apt/lists/*

#We need to copy the pg-cron.sh to docker-entrypoint-initdb.d folder b/c the image runs all file in this folder.
#pg-cron.sh: it adds cron.database_name and shared_preload_libraries = 'pg_cron' to postgresql.conf
COPY ./dockerfile/postgres_17/pg-cron.sh ./docker-entrypoint-initdb.d

#set the execution access to pg-cron.sh so that the image runs this file
RUN chmod +x ./docker-entrypoint-initdb.d/pg-cron.sh

# Install pg_partman 5.0.1 (latest stable release)
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    postgresql-server-dev-17 \
    && git clone https://github.com/pgpartman/pg_partman.git /tmp/pg_partman \
    && cd /tmp/pg_partman \
    && git checkout v5.0.1 \
    && make \
    && make install \
    # Cleanup build files and tools
    && apt-get remove -y git build-essential postgresql-server-dev-17 \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/pg_partman

# Install pg_jobmon 1.4.1 (latest stable release)
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    postgresql-server-dev-17 \
    && git clone https://github.com/omniti-labs/pg_jobmon.git /tmp/pg_jobmon \
    && cd /tmp/pg_jobmon \
    && git checkout v1.4.1 \  
    && make \
    && make install \
    # Cleanup build files and tools
    && apt-get remove -y git build-essential postgresql-server-dev-17 \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/pg_jobmon    

USER postgres
