module Handlers
  class Twitter < Base
    setting :consumer_key
    setting :consumer_secret
    setting :access_token
    setting :access_token_secret
    setting :message

    def call
      client = ::Twitter::REST::Client.new do |config|
        config.consumer_key = consumer_key.presence || ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret = consumer_secret.presence || ENV['TWITTER_CONSUMER_SECRET']
        config.access_token = access_token.presence || ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = access_token_secret.presence || ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end

      client.update(message)
    end
  end
end
