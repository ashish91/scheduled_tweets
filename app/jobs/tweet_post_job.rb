class TweetPostJob < ApplicationJob
  queue_as :default

  def perform(tweet_id)
    tweet = Tweet.find_by(id: tweet_id)
    return if tweet.nil? || tweet.published? || !within_publish_at?(tweet)

    tweeting_service = XTweetingService.new(tweet.token, tweet.secret)
    response = tweeting_service.publish_to_twitter!(tweet)

    tweet.update!(tweet_id: response.tweet_id)
  end

  private
    def within_publish_at?(tweet)
      beginning_buffer = Time.current - 5.minutes
      end_buffer = Time.current + 5.minutes

      beginning_buffer <= tweet.publish_at && tweet.publish_at <= end_buffer
    end

end
