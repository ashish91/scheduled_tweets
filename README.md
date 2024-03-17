# Scheduled Tweets

Scheduled Tweets is a Rails based project which helps users to publish tweets on their twitter accounts. Tweets are scheduled to be published when created. The scheduled time and the tweet content can be edited before the scheduled time.

This project uses Omniauth to authenticate user in Twitter. It uses the [twitter ruby gem](https://github.com/sferik/x-ruby) to interact with Twitter API.

# Features

## Sign Up

Users can sign up with an email. Email must be unique and valid.


https://github.com/ashish91/scheduled_tweets/assets/2291064/b59139b4-d9a4-4921-8c55-9ef9cbc2f94c


#### Storing password digest for users

On sign up the user email and password is stored. The password is stored using the [has_secure_password](https://api.rubyonrails.org/v7.1.3/classes/ActiveModel/SecurePassword/ClassMethods.html) feature in Rails. This feature allows two virtual attributes - password and password_confirmation which is inputted by the user. During saving it uses the bcryt hashing function to create a password digest which is then stored in the database. The same bcrypt function is used to produce a digest on sign in and this is then matched with the digest stored in the database.

Storing the digest instead of the password itself prevents exposing user password on possible database leaks or hacks.

## Sign In/Sign Out

Once a user has signed up they can sign in with the email and password.

#### Persisting sessions after user sign in

On a successful sign in the user's id is stored in the browser's cookie. After that during each request the browser adds the user id present in session in the header, on the server side the value is picked up from the header and logged in user is initialized.
On sign out the session's users id is deleted. And from thereon the user id is not passed in the header, the server doesn't find the user id in the header and redirects the user to sign in page.

#### What is a Browser Cookie ?

A Browser Cookie, also known as HTTP Cookie, is a small piece of data that a server sends to the user's browser using `Set-Cookie HTTP response header`. After the cookie is set, the browser sends it back to the server with each request in the request header.

## Forgot Password

An existing user can use forgot password to change their password. A reset link is generated which can be used to update the password. The reset link contains a token which expires in 15 mins rendering the link invalid after the expiration time.

#### How is token generated for reset link ?

Every model instance in Rails has a [global id](https://github.com/rails/globalid), this can be accessed using `to_global_id` method of the `ActiveRecord` instance. Using this `global id` a signed version is created using the `signed_id` method. This `signed_id` method also contains a `expires_in` attribute, using this we can generate a signed id and use that to get the user instance afterwards using `find_signed`. The `signed_id` becomes invalid after the `expires_in` time and makes the password link also invalid.

## Connect/Disconnect Twitter Accounts

A user can connect multiple twitter accounts to post tweets to those accounts. The connected twitter accounts also can be disconnected afterwards.

#### Using 3-legged OAuth for authenticating users on Twitter

On connecting a Twitter Account, the Rails app uses Omniauth to authorize a twitter application. This is done using 3-legged OAuth. In 3-legged OAuth following things happen:

- A post request is made to the Rails app on `/auth/twitter` url.
- The Rails app then redirects to the Twitter app with the `api_key` and `api_secret` associated to your Twitter Account's developer app.
- Twitter authorizes your Twitter Account's developer app using the `api_key` and `api_secret`, if authorized it redirects back to the Rails app with a `token` and `secret`.

This `token` and `secret` is used to authenticate your account afterwards to post tweets on your Twitter account.

## Create/Edit Tweets

A user can create a tweet, for doing so user must provide the body of the tweet, the time at which the tweet should be published and the twitter account to which the tweet needs to be published has to be selected.

#### Publishing tweets on Twitter using background jobs

Once a tweet is created, it's scheduled to be published on Twitter using a background job running on Sidekiq. Tweets are allowed to be edited before the scheduled time where the user can change the body of the tweet and publish_at time/date.
