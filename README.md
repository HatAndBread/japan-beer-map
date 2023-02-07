# Japan Beer Map
This is the sourcecode for the website https://www.japanbeermap.com/

## Requirements
* Ruby version: 3.2.0
* PostgreSQL
* Rails 7
* Frontend💅: [Phlex](https://www.phlex.fun/), Tailwind, Hotwire

## Setup
Create .env file. Ask for secret keys.
It should look like this:
```
ADMIN_PASSWORD=secret
MAPBOX_KEY=secret
ADMIN_EMAIL_PASSWORD=secret
MAIN_EMAIL=japanbeermap@gmail.com
CLOUDINARY_URL=secret
GOOGLE=secret
```

Run the following in the root directory:
```bash
bundle
rails db:create
rails db:migrate
make pull # Pull the database to your local system
bin/dev
```