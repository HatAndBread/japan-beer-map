pull: 
	DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop
	DATABASE_URL=$(heroku config:get DATABASE_URL) heroku pg:pull DATABASE_URL japan_beer_map_development --app craft-beer-map
	DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:test:prepare
