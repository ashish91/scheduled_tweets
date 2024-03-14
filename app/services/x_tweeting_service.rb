class XTweetingService

  def initialize(token, secret)
    @client = XApiClientService.new(token, secret)
  end

  def publish_to_twitter!(tweet)
    @client.post(tweet.body)
  end

end
