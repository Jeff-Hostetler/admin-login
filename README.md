## Purpose 
Sinatra API with JWT auth for users
## Setup
- requires ruby 2.3
- bundle install
### setup the db
```
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```
### environment
see .env_example for details

# Running Server
```
bundle exec rackup

```
- starts on port 9292

# Playing with endpoints
- get postman chrome extension

# Sources
see https://auth0.com/blog/ruby-authentication-secure-rack-apps-with-jwt/ for jwt stuff