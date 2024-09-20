# ARCHIVED

This project is no longer maintained and will not receive any further updates. If you plan to continue using it, please be aware that future security issues will not be addressed.

# AWI NearRealTime Example Database

Extract of the AWI NearRealTime database for development purposes.

## Building

Just build the Docker image:
```sh
docker build -t awi/nearrealtime-example-db:latest .
```

## Running

This image uses [`mdillon/postgis:9.6-alpine`](https://hub.docker.com/r/mdillon/postgis) 
and [`postgres:9.6-alpine`](https://hub.docker.com/_/postgres) as it's base, so their 
configuration parameters apply to this image as well. Particulary the environment variables
`POSTGRES_DB`, `POSTGRES_USER`, and `POSTGRES_PASSWORD` should be supplied:

```sh
docker run --rm -it -p 5432:5432 \
  -e POSTGRES_DB=nearrealtime \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  awi/nearrealtime-example-db:latest
```
