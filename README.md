# Weather App
This application uses OpenWeatherMap API to show you your current and future weather forecast.

## Configuration
This app utilizes a Ruby on Rails backend and React.js frontend.
- Install rbenv
  https://github.com/rbenv/rbenv
- Install correct ruby version
  `rbenv install $(cat .ruby-version)`
- Install redis
  https://redis.io/docs/getting-started/
- Install ruby on rails
  https://guides.rubyonrails.org/getting_started.html#creating-a-new-rails-project-installing-rails
- Install gems
  `bundle install`
- Install frontend packages
  `yarn install`
- Run server
  Note: `rails s` does not build the React app you must use the following command
  `./bin/dev`

## Testing
`bundle exec rspec`

## Screenshots

<img width="739" alt="Screenshot 2023-01-06 at 8 37 37 PM" src="https://user-images.githubusercontent.com/3744916/211122901-50ab23d0-8553-4922-8bf7-3ceb6a4ab46f.png">
