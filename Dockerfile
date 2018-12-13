FROM mdillon/postgis:9.6-alpine

RUN apk add --no-cache xz

RUN mkdir -p /docker-entrypoint-initdb.d/data

COPY ./data/*         /docker-entrypoint-initdb.d/data/
COPY ./schema.sql     /docker-entrypoint-initdb.d/zz-97-nrt-schema.sql
COPY ./import_data.sh /docker-entrypoint-initdb.d/zz-98-nrt-data.sh
