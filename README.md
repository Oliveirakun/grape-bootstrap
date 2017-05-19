# Grape Bootstrap

## Introduction

Bootstrap Grape application for REST APIS with ActiveRecord, RSpec and Swagger integration

## Dependencies

- Ruby 2.3.0
- MySQL

## Installation

- Clone poject
- Run the script:

 ```shell
 $ bin/setup
 ```

- Run bundler:

 ```shell
 $ bundle install
 ```

- Create database and run migrations:

 ```shell
 $ bundle exec rake db:create db:migrate
 ```

- Run application:

 ```shell
 $ rackup -p 3000
 ```

## Docker

To run application on docker:

- Install Docker and Docker-Compose
- Clone the project
- Run these commands on project root:

```shell
$ docker-compose build
$ docker-compose up

# Open another terminal and run:
$ docker-compose run web bundle exec rake db:create db:migrate
```

## Console

To use console, run the following command:

```shell
$ bin/console
```

## Tests

To execute tests, run the following command:

```shell
$ bundle exec rspec
```

## Routes

To show the application routes, run the following command:

```shell
$ bundle exec rake routes
```

## Swagger Documentation

To access swagger documentation, enter the root application address in the browser:

```shell
http://localhost:3000
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Oliveirakun/grape-bootstrap.

## License

The software is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).