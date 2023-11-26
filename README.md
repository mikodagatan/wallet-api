# Wallet API

A simple but efficient solution to depositing, withdrawing, and transferring your cash.

## Setup

- Create an `.env` file with the structure from `.env.example`.
- run `bundle install`
- Make sure PostgreSQL and Redis are running.
- run `rails db:create`
- run `rails db:migrate`
- run `rails s`

## Create a User

To create a user, we're using Google email authentication. To authenticate and create a user, go to `/auth/login`, with a GET request. The API will respond with a redirect url. Redirect your user to the given redirect url to let him go through the google authentication process.

## Authorization

The API uses JWT in certain endpoints. Use the `/auth/login` endpoint and with a successful authentication, Google will redirect to a callback function which will provide the token. Add an `Authorization` header with the `Bearer <token>` value in your requests.
