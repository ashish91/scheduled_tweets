class XPostResponse < XResponse
  def initialize(response)
    @data = response['data']
  end

  def tweet_id
    @data['id']
  end
end
