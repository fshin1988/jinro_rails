# Jinro Rails
Jinro Rails is the open source werewolf game application.
You can play the werewolf game with chat.

## Screenshots
![](docs/screenshot_pc.png)
![](docs/screenshot_sp.png)

## Built with
Jinro Rails is built with following libraries.

- Ruby
- Ruby on Rails
- Vue.js
- PostgreSQL
- Redis
- Sidekiq

## Development
```
# prepare for middlewares
cp docker-compose.override.yml.sample docker-compose.override.yml
docker compose up

# run rails server
cp dotenv.sample .env
bin/setup
bin/rails s
bin/webpack-dev-server

# run worker
bundle exec sidekiq
```

To update the application you just run `bin/update`.

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/fshin1988/jinro_rails

## License
The application is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
