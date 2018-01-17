# README

Hello! This is my coding challenge for LendUp.

To run locally on your machine:
1. Enter your Twilio credentials in config/secrets.yml
2. Start your rails server with the terminal command
```sh
rails s
```
3. Start ngrok in another terminal tab/window with
```sh
ngrok http 3000
```
4. Copy the forwarding link to 'application_url' in config/secrets.yml and your Twilio phone number's programmable voice request URL in the Twilio console. The request type should be HTTP POST. 
