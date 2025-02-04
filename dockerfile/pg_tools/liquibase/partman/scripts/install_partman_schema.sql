--liquibase formatted sql

--===============================================================================================--
-- PARTMAN ==
---------------------------------------------------------------------------------------------------
--changeset jozsef.holczer:${schema_name}-INSTALL_PARTMAN_SCHEMA dbms:postgresql runOnChange:true
--comment Creation of the partman postgres schema
---------------------------------------------------------------------------------------------------
CREATE SCHEMA IF NOT EXISTS partman;



