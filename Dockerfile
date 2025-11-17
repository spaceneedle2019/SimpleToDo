FROM postgres:17-alpine

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
EXPOSE 5432

VOLUME ["/var/lib/postgresql/data"]
