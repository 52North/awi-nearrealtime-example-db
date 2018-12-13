#!/bin/bash

set -x

DATA_DIR='/docker-entrypoint-initdb.d/data'

for t in platform device sensor v_expedition dataview; 
do
	xz -c -d "${DATA_DIR}/${t}.csv.xz" \
		| "${psql[@]}" -c "COPY ${t} FROM STDIN (FORMAT 'csv', HEADER);"
done

