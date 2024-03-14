# Introducing the Project

# Features Flows

## Sign Up

Hey guys, In this video we're going to go through the sign up flow.

For signing up we're going to click on Sign Up. This will now ask us to type in email and password.

So lets type in my email - your email - and for password I'll choose the good old password.

Once we click on Sign up it should create a user for us with the email id - your email -.


Ok it's Successfully created my account. Let's go to Rails console to check the new user.

**Type in User.last**

So it has indeed created my account using - my email -. We can also see that it saved the password digest and not the password we typed in. Here we're using a feature in Rails called `has_secure_password` which uses a hashing algorithm called `bcrypt` to hash the password we entered and save the digest outputed by it. This is done so that nobody can read the actual password we provided.

Afterwards when we're signing it uses the same `bcrypt` hashing algorithm to hash the password input and matches it to what is saved in the database. If it matches it signs in the user.

Currently as we can see it has signed us in using the email we provided earlier. Let's try signing in in the next video.


## Sign In/Sign Out

Hey guys, In the previous video we went through the sign up flow, if you haven't I would suggest to go through it once before watching this one.

We'll try to sign in with the email we used before to sign up.

First we'll click on Log In, now here we'll input the email and password we used in the sign up flow.

Once we click Sign In we should be logged in, that'll create a session for our user. So let's try that and we're Logged in Successfully.

Now interesting thing to note here is that our session is stored in a browser cookie. Let me show you by going to the browser's inspection tool -> Application and Cookies. Under localhost we can see `_scheduled_tweet_session` which is created by our Rails app and can be accessed in our application using the `session` method.

Let's look at the `sessions_controller` to check how we use the `session` method. As we can see here we're storing the user id in our session cookie in the line `session[:user_id] = user.id`. Once we store user id in the cookie, the browser sends it with each request. Then we fetch it using `session[:user_id]`, initialize the user from our database and use it in subsequent requests. This how if persist users across requests.

So what happens if we log out ? Once we hit the log out button the user id value is deleted from the session cookie. So in subsequent requests the `user id` is not sent anymore.

Let's check what happens when we go to Twitter Accounts. It redirects us back to Sign In page. In the background what happens is that we try to find `user id` in cookie header but it's not there anymore, so we redirect the user back to Sign In page.

If we log back in it'll again set the userid in our `session` and we'll be logged in.

Let's check how Forget password works in the next video

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
