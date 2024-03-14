require "x"

class XApiClientService

  def initialize(access_token, access_token_secret)
    credentials = {
      api_key:             Rails.application.credentials.dig(:twitter, :api_key),
      api_key_secret:      Rails.application.credentials.dig(:twitter, :api_secret),
      access_token:        access_token,
      access_token_secret: access_token_secret,
    }

    # Initialize an X API client with your OAuth credentials
    @client = X::Client.new(**credentials)

    # # Get data about yourself
    # x_client.get("users/me")
    # # {"data"=>{"id"=>"7505382", "name"=>"Erik Berlin", "username"=>"sferik"}}

    # # Delete the post
    # x_client.delete("tweets/#{post["data"]["id"]}")
    # # {"data"=>{"deleted"=>true}}

    # # Initialize an API v1.1 client
    # v1_client = X::Client.new(base_url: "https://api.twitter.com/1.1/", **x_credentials)

    # # Define a custom response object
    # Language = Struct.new(:code, :name, :local_name, :status, :debug)

    # # Parse a response with custom array and object classes
    # languages = v1_client.get("help/languages.json", object_class: Language, array_class: Set)
    # # #<Set: {#<struct Language code="ur", name="Urdu", local_name="اردو", status="beta", debug=false>, …

    # # Access data with dots instead of brackets
    # languages.first.local_name

    # # Initialize an Ads API client
    # ads_client = X::Client.new(base_url: "https://ads-api.twitter.com/12/", **x_credentials)

    # # Get your ad accounts
    # ads_client.get("accounts")
  end

  def post(text)
    # Returns: {"data"=>{"edit_history_tweet_ids"=>["1234567890123456789"], "id"=>"1234567890123456789", "text"=>"Hello, World! (from @gem)"}}
    post_response = @client.post("tweets", {"text": text}.to_json)
    XPostResponse.new(post_response)
  end

end
