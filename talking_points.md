# Introducing the Project

# Features Flows

## Sign Up

Hey guys, In this video we're going to go through the sign up flow.

For signing up we're going to click on Sign Up. This will now ask us to type in email and password.

So lets type in my email - your email - and for password I'll choose the good old password.

Once we click on Sign up it should create a user for us with the email id - your email -.


Ok it's Successfully created my account. Let's go to Rails console to check the new user.

Type in User.last

This is the newly create user with - my email -.

We can also see that it saved the password digest and not the password we typed in.

Here we're using a feature in Rails called `has_secure_password` which uses a hashing algorithm called `bcrypt` to hash the password we entered and save the digest outputed by it.

This is done so that nobody can read the actual password we provided.

Afterwards when we're signing it uses the same `bcrypt` hashing algorithm to hash the password input and matches it to what is saved in the database. If it matches it signs in the user.

Currently as we can see it has signed us in using the email we provided earlier. Let's try signing in in the next video.


## Sign In/Sign Out

Hey guys, In the previous video we went through the sign up flow, if you haven't I would suggest to go through it once before watching this one.

We'll try to sign in with the email we used before to sign up.

First we'll click on Log In, now here we'll input the email and password we used in the sign up flow.

Once we click Sign In we should be logged in, that'll create a session for our user. So let's try that and we're Logged in Successfully.



Now interesting thing is how is our session persisted ?

So how we're doing that is by storing the user id in the browser cookie.

Lets check by going to the browser's inspection tool -> Application and Cookies.

Under localhost we can see `_scheduled_tweet_session` which is created by our Rails app and can be accessed in our application using the `session` method.

Let's look at the `sessions_controller` to check how we use the `session` method.

As we can see here we're storing the user id in our session cookie in the line `session[:user_id] = user.id`.

Once we store user id in the cookie, the browser sends it with each request.

Then we fetch it using `session[:user_id]`, initialize the user from our database and use it in subsequent requests.

This how users are persisted across requests.



So what happens if we log out ?

When log out the user id value is deleted from the `session` cookie. So the subsequent requests will not have the `user id` anymore.


Let's check what happens when we go to Twitter Accounts.

It redirects us back to Sign In page.

In the background what happens is that we try to find `user id` in cookie header but it's not there anymore, so we redirect the user back to Sign In page.



If we log back in it'll again set the userid in our `session` and we'll be logged in.

Let's check how Forget password works in the next video

## Forgot Password

Hey guys, In this video we're going to go through forgot password flow.

So lets go to login, then click Forgot password. Now here we will type in our email and hit Reset Password.

This will generate a reset link and mail to our email. If we check out our rails log we can see the reset link there.

Here is the reset link => http://localhost:3000/password/reset/edit?token=eyJfcmFpbHMiOnsibWVzc2FnZSI6Ik1RPT0iLCJleHAiOiIyMDI0LTAzLTE1VDA0OjI0OjI3LjYyMVoiLCJwdXIiOiJ1c2VyL3Bhc3N3b3JkX3Jlc2V0In19--e5738b3e4cb56cfee2bad4a30d507b06f05787e37796ac8a6e414a1628e390cc

Let's open that. We're landed to the password reset page, so let's type in our new password.

Ok password was updated successfully. Let's sign in with our new password. Ok great our new password works.

Now let's talk about how the password reset is generated. If we go to `password_mailer` we can see that it generates a `token` using `signed_id` method. In the password mailer's view we can see the link being generated which adds the `token` in the param.

This `token` is used to find the user afterwards when we go to the password reset link. If we open `password_resets_controller` in the edit action we can see the user is grabbed by using the `find_signed!` method.

Now what is this `find_signed!` and `signed_id` method. So Rails has a global id associated with each model instance, let's go to console and check it out for our user using the `to_global_id`.

This global id is used in `signed_id` method to generated an encrypted version of it. This is done so that nobody read your global id. Then `find_signed!` method uses this `signed_id` to get the user. `signed_id` also accepts a `expires_in` parameter which invalidates the token after the mentioned time, rendering the reset link invalid.

That's all for Forgot password. In the next video we'll look at how to connect and disconnect our twitter accounts.

## Connect/Disconnect Twitter Accounts

Hey guys, In this video we'll connect our twitter account. So let's go to Twitter Accounts.

Click on Connect Twitter Account button. This will initiate a 3-legged OAuth.

Basically we're doing a post request to Rails app which in turn redirects us to the Twitter auth callback url with our api key and secret, and then Twitter uses those key and secret to authorize us and sends back an access token and access secret back to our Rails app.

Ok so let's click that and see it live. Ok it Successfully connected our account.

Let's check out our account in Twitter accounts. Great, so our twitter account is linked and if I click on it, it takes to my twitter page.

We can also disconnect our account by clicking this Disconnect button. But before that let's check out the access token and access secret which Twitter sent back.

We'll go to the Rails console and check out our user's newly created twitter account. Ok, we can see our twitter account and we can also see the token and secret with it which obviously filtered.

This token and secret is used afterwards when our Rails app publishes tweets to our twitter account.

Let's now disconnect this account to see what happens. Ok, it Successfully disconnected my account. Let's check the twitter accounts for our user now. So there you go it's been deleted.

In the next video we'll see how to create tweets and how to publishes to our twitter account. For that I'll reconnect our account.



## Create/Edit Tweets

Hey guys, in this video we're going to create tweets and publish them in our twitter account.

Let's click the Schedule a tweet button. Here we can select a twitter account where it should be published, the tweet body and the time at which this should be scheduled.

So let's create a test tweet. The date will be tomorrow same time. This created our tweet which is scheduled to be published tomorrow. We can also see on which account this will be published by clicking on the icon link.

We can edit the tweet before its scheduled time. Let's do that by clicking Edit Tweet and here we can change the body and the scheduled time. So let's change the body and the scheduled time.

So we can see now our updated tweet with new scheduled time. We can also delete this tweet by going to Edit Tweet and clicking on this Delete Tweet button. Now we cannot see it anymore as it's deleted.

Lets schedule a tweet to be published in the next 2 minutes so we can see it being published on our twitter account.

Now this will get published to our account around 10:11.

Ok let's go to our twitter account and here we can see our tweet published. The publishing of tweet is done using Sidekiq which is used for background processing.

That's all.

Thank you for watching this.

Have a nice day.
