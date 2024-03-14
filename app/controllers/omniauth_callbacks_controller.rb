class OmniauthCallbacksController < ApplicationController

  def twitter
    Rails.logger.info(auth)

    twitter_account = Current.user.twitter_accounts.where(username: auth.info.nickname).
      first_or_initialize(
        name: auth.info.name,
        username: auth.info.nickname,
        image: auth.info.image,
        token: auth.credentials.token,
        secret: auth.credentials.secret,
      )
    twitter_account.save!

    redirect_to root_path, notice: "Successfully connected your account"
  end

  def auth
    request.env['omniauth.auth']
  end

end
