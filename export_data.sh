#!/bin/bash -e

rm -rf data
mkdir -p data

DATA_SINCE='2015-01-01'
DATA_BEFORE='2018-01-01'
DATA_DIR='data'

psql=(psql -v ON_ERROR_STOP=1 
      --username nrtread 
      --dbname nearrealtime 
      --host localhost 
      --port 15432)

${psql[@]} <<-EOF | xz > ${DATA_DIR}/device.csv.xz 
  COPY (
    SELECT DISTINCT
      device.device_id,
      device.device,
      device.platform_id,
      device.code
    FROM sensor 
      LEFT JOIN device ON (sensor.device_id = device.device_id)
      LEFT JOIN platform ON (device.platform_id = platform.platform_id)
    WHERE
      sensor.code IS NOT NULL 
      AND device.code IS NOT NULL
      AND platform.code IS NOT NULL
      AND platform.type IS NOT NULL
      AND platform.public
  ) TO STDOUT (FORMAT 'csv', HEADER);
EOF

${psql[@]} <<-EOF | xz > ${DATA_DIR}/platform.csv.xz 
  COPY (
    SELECT DISTINCT
      platform.platform_id,
      platform.platform,
      platform.code,
      platform.type,
      platform.latitude,
      platform.longitude,
      platform.public
    FROM sensor 
      LEFT JOIN device ON (sensor.device_id = device.device_id)
      LEFT JOIN platform ON (device.platform_id = platform.platform_id)
    WHERE
      sensor.code IS NOT NULL 
      AND device.code IS NOT NULL
      AND platform.code IS NOT NULL
      AND platform.type IS NOT NULL
      AND platform.public
  ) TO STDOUT (FORMAT 'csv', HEADER);
EOF

${psql[@]} <<-EOF | xz > ${DATA_DIR}/sensor.csv.xz 
  COPY (
    SELECT DISTINCT
      sensor.sensor_id, 
      sensor.sensor, 
      sensor.device_id,
      sensor.unit,
      sensor.code
    FROM sensor 
      LEFT JOIN device ON (sensor.device_id = device.device_id)
      LEFT JOIN platform ON (device.platform_id = platform.platform_id)
    WHERE
      sensor.code IS NOT NULL 
      AND device.code IS NOT NULL
      AND platform.code IS NOT NULL
      AND platform.type IS NOT NULL
      AND platform.public
  ) TO STDOUT (FORMAT 'csv', HEADER);
EOF

${psql[@]} <<-EOF | xz > ${DATA_DIR}/v_expedition.csv.xz 
  COPY (
    SELECT 
      v_expedition.platform_id, 
      v_expedition.expedition, 
      v_expedition.begin_date, 
      v_expedition.end_date, 
      v_expedition.geom
    FROM v_expedition 
      LEFT JOIN platform ON (v_expedition.platform_id = platform.platform_id)
    WHERE 
      v_expedition.begin_date <= v_expedition.end_date
      AND platform.code IS NOT NULL
      AND platform.type IS NOT NULL
      AND platform.public
      AND v_expedition.end_date >= '${DATA_SINCE}'
      AND v_expedition.begin_date < '${DATA_BEFORE}'
  ) TO STDOUT (FORMAT 'csv', HEADER);
EOF

${psql[@]} <<-EOF | xz > ${DATA_DIR}/dataview.csv.xz 
  COPY (
    SELECT 
    dataview.sensor_id,
    dataview.date,
    dataview.mean,
    dataview.longitude,
    dataview.latitude
    FROM dataview
      LEFT JOIN sensor ON (dataview.sensor_id = sensor.sensor_id)
      LEFT JOIN device ON (sensor.device_id = device.device_id)
      LEFT JOIN platform ON (device.platform_id = platform.platform_id)
    WHERE 
      sensor.code IS NOT NULL 
      AND device.code IS NOT NULL
      AND platform.code IS NOT NULL
      AND platform.type IS NOT NULL
      AND platform.public
      AND dataview.date >='${DATA_SINCE}'
      AND dataview.date < '${DATA_BEFORE}'
  ) TO STDOUT (FORMAT 'csv', HEADER);
EOF

exit 0
