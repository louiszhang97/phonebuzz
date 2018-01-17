# README

Hello! This is my coding challenge for LendUp. You'll need:
1. A Twilio Account
2. A Twilio phone number
3. Rails, Ngrok, and PostgreSQL installed on your machine

To run locally on your machine:
1. Enter your Twilio credentials in config/secrets.yml
2. Initialize your rails database with the terminal command
```sh
rake db:create
```
3. Start your rails server with the terminal command
```sh
rails s
```
4. Start ngrok in another terminal tab/window with
```sh
ngrok http 3000
```
5. Copy the forwarding link to 'application_url' in config/secrets.yml and your Twilio phone number's programmable voice request URL in the Twilio console. The request type should be HTTP POST.
6. Enter the forwarding link in your application's browser.
