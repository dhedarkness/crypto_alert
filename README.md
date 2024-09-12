# crypto_alert
Containerized solution service. that uses Websocket to update the price of bitcoin in realtime. Users can hit apis to create users, and alerts. if they provide their mail, they'll receive one through action mailer when the price hits their target price from the alert

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

# Use this guide(https://gorails.com/setup/macos/14-sonoma) and choose the specific OS to install all dependencies 
* Ruby version: 3.3

* System dependencies Mac/Linux

* Configuration, rails v7.1.4.2

* Database creation postgresql( brew install postgres; create a new db and a new user with password specify in database.yml)

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# Overview
to get into the database
docker-compose exec db bash
psql -U postgres -d crypto_alerts_development

to run any rails commands, prefix docker-compose run web

# The steps to run the project
docker-compose build
docker-compose up
docker-compose run web rails db:create
docker-compose run web rails db:migrate
docker-compose run web rails runner 'PriceUpdateService.new.run'
docker-compose run web rails 

# DOCKER COMMANDS USED
docker-compose run web rails g scaffold User name:string
docker-compose run web rails g scaffold Alert cryptocurrency:string target_price:decimal user:references status:integer 
docker-compose run web rails g job PriceDropService


# EndPoints
user_name is a required param, using this instead of authorizing with devise.

CREATE USERS:
Post Requests at /users to create Users
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"name": "prasanna", "email": "prasanna@123.com"}'

CREATE ALERT:
Post Requests at /alerts to create
curl -X POST http://localhost:3000/alerts \
  -H "Content-Type: application/json" \
  -d '{"user_name": "prasanna", "email": "prasanna@123.xyz", "cryptocurrency": "BTC", "target_price": 30000, "name": "whooo"}'

DELETE ALERT(updates status)
Delete Requests at /alerts to delete with alert id or alert's name given during creation
curl -X DELETE http://localhost:3000/alerts \
  -H "Content-Type: application/json" \
  -d '{"user_name": "prasanna", "name": "whooo"}'

DELETE ALERT (w id)
curl -X DELETE http://localhost:3000/alerts/1
  -d '{"user_name": "prasanna"}'


FETCH ALERTS:
Get Requests at /alerts to fetch all alerts of a user
curl -i -H "Accept: application/json" \
     -H "Content-Type: application/json" \
     -X GET http://localhost:3000/alerts?user_name=prasanna \

FETCH ALERTS(w filters):
curl -X GET "http://localhost:3000/alerts?status=triggered&user_name=prasanna"
curl -X GET "http://localhost:3000/alerts?status=deleted&user_name=prasanna"
curl -X GET "http://localhost:3000/alerts?user_name=prasanna&status=created"


# Sending Alerts:
The PriceUpdateService has to be run by using the following command and is not automated through docker
docker-compose run web rails runner 'PriceUpdateService.new.run'

# FUTURE TASKS
1. PriceUpdateService runs separately and can be automated to run via sidekiq every 1 minute in the future
2. Needs better log in service using jwt tokens. 
3. Alerts and the current price service may need to be in sync(when creating the alert to see if price needs to exceed or go below)