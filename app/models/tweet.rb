class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :twitter_account

  validates :body, length: { minimum: 10, maximum: 280 }
  validates :publish_at, presence: true

  delegate :token, :secret, to: :twitter_account

  # after_commit :publish_tweet!
  # after_initialize :set_default_publish_at

  def published?
    tweet_id?
  end

  private

    def set_default_publish_at
      self.publish_at ||= 24.hours.from_now
    end

    def publish_tweet!
      binding.irb
      return unless publish_at_previously_changed?

      TweetCreateJob.set(wait_until: self.publish_at).perform_later(self.id)
    end

end
