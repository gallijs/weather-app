# Weather App
This application uses OpenWeatherMap API to show you your current and future weather forecast.

Working Demo: https://weatherjs.fly.dev/

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
![weatherapp](https://user-images.githubusercontent.com/3744916/211128507-3004d576-287b-4649-8313-d603b57ac07e.gif)

## Acknowledgement
Thanks to [Colin Espinas](https://colinespinas.com/) for publishing a great weather app design that I could implement on this project. 
