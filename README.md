# SimpleToDo

Backend for the SimpleToDo app.

## Prerequisite

1. Install Ruby base with `bundle`
2. Install node base with `npm i`
3. Initialize Docker environment for PostgreSQL support
    * `docker-compose pull`
    * `docker-compose build`
4. Run Docker environment with `docker-compose up -d`

## Setup and run

1. Create development database with `bundle exec rake db:create db:migrate`
2. Run Puma server with `bundle exec puma`
3. The service API will be served under `http://0.0.0.0:9292`

## Test

1. Create test database with `RACK_ENV=test bundle exec rake db:create db:migrate`
2. Run tests with `bundle exec rake`

This will automatically create the test coverage overview
(`coverage/index.html`) and the interactive API documentation (`openapi/api-doc.html`).
