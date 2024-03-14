# Scheduled Tweets

Scheduled Tweets is a Rails based project which helps users to publish tweets on their twitter accounts. Tweets are scheduled to be published when created. The scheduled time and the tweet content can be edited before the scheduled time.

This project uses Omniauth to authenticate user in Twitter. It uses the [twitter ruby gem](https://github.com/sferik/x-ruby) to interact with Twitter API.

# Features

## Sign Up

Users can sign up with an email. Email must be unique and valid.

## Sign In/Sign Out

Once a user has signed up they can sign in with the email and password.

## Forgot Password

An existing user can use forgot password to change their password. A reset link is generated which can used to update the password. The reset link expires after 15 mins.

## Connect/Disconnect Twitter Accounts

A user can connect multiple twitter accounts to post tweets to those accounts. The connected twitter accounts also can be disconnected afterwards.

## Create/Edit Tweets

A user can create a tweet, for doing so user must provide the body of the tweet, the time at which the tweet should be published and the twitter account to which the tweet needs to be published has to be selected.

# To Dos

- Debug Sidekiq time scheduled jobs
