#!/bin/bash
mvn -Dflyway-user=postgres -Dflyway.password -Dflyway.url=jdbc:postgresql://localhost:5432/getuwettkaempfe flyway:repair
