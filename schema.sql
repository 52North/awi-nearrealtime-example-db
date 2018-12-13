DROP TABLE IF EXISTS platform;
DROP TABLE IF EXISTS device;
DROP TABLE IF EXISTS sensor;
DROP TABLE IF EXISTS dataview;
DROP TABLE IF EXISTS v_expedition;

CREATE TABLE platform (
  platform_id integer PRIMARY KEY,
  platform character varying(256) NOT NULL,
  code character varying,
  type character varying,
  latitude double precision,
  longitude double precision,
  public boolean
);

CREATE TABLE device (
  device_id integer PRIMARY KEY,
  device character varying(256) NOT NULL,
  platform_id integer NOT NULL,
  code character varying,
  CONSTRAINT device_platform_id_fkey FOREIGN KEY (platform_id)
      REFERENCES platform (platform_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE sensor (
  sensor_id integer PRIMARY KEY,
  sensor character varying(256) NOT NULL,
  device_id integer NOT NULL,
  unit character varying(10),
  code character varying,
  CONSTRAINT sensor_device_id_fkey FOREIGN KEY (device_id)
      REFERENCES device (device_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE dataview (
  sensor_id integer,
  date timestamp without time zone,
  mean double precision,
  longitude double precision,
  latitude double precision,
  CONSTRAINT data_sensor_id_fkey FOREIGN KEY (sensor_id)
      REFERENCES sensor (sensor_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE v_expedition (
    platform_id integer NOT NULL,
    expedition character varying,
    begin_date timestamp without time zone,
    end_date timestamp without time zone,
    geom geometry,
    CONSTRAINT v_expedition_platform_id_fkey FOREIGN KEY (platform_id)
      REFERENCES platform (platform_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE INDEX ON dataview (date);
CREATE INDEX ON dataview (latitude);
CREATE INDEX ON dataview (longitude);
CREATE INDEX ON device (device);
CREATE INDEX ON sensor (sensor);
CREATE INDEX ON platform (platform);
CREATE INDEX ON v_expedition (expedition);
