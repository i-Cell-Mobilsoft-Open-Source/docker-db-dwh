--liquibase formatted sql
--changeset jozsef.holczer:${schema_name}-PG_CRON-DCKDBDWH-20 dbms:postgresql runOnChange:true
--comment install pg_cron extension

CREATE extension IF NOT EXISTS pg_cron;

