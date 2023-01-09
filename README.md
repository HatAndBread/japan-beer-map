# Japan Beer Map

## Requirements
* Ruby version: 3.2.0
* PostgreSQL
* Rails 7
* Frontend💅: [Phlex](https://www.phlex.fun/), Tailwind, Hotwire

## Setup
Create .env file. Ask for secret keys.
It should look like this:
```
ADMIN_PASSWORD=password
MAPBOX_KEY=add_the_secret_key_here
```

Run the following in the root directory:
```bash
rails db:create
rails db:migrate
rails db:seed
bin/dev
```

## Why?
Let's learn Hotwire!
