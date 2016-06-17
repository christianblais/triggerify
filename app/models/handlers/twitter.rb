module Handlers
  class Twitter < Base
    description %(
      Use the Twitter API to send a tweet.
      <a href="https://apps.twitter.com" target="_blank">Click here</a>
      for more information.
    )

    setting :consumer_key,
      info: 'Twitter consumer key',
      example: 'af5wRasYyoPbjwLhCrPEOVz4b'

    setting :consumer_secret,
      info: 'Twitter consumer secret',
      example: 'u2CDLa9pdN8PuPk4diUvnzRfL4vCmxdsajhdsa16673276dds'

    setting :access_token,
      info: 'Twitter access token',
      example: '41051328-5yWpFXcSsHmyk7i7JORiQUna6f9YLvnGDONk0vhw6'

    setting :access_token_secret,
      info: 'Twitter secret token',
      example: 'Hvav8FUhjJiWgHbfqKk7L91dBSRyoDbxlexVSa1qNTd88'

    setting :message,
      info: 'Message of the Tweet',
      example: 'New order from {{ first_name }}!'

    def call
      computed_consumer_key = consumer_key.presence || ENV['TWITTER_CONSUMER_KEY']
      computed_consumer_secret = consumer_secret.presence || ENV['TWITTER_CONSUMER_SECRET']
      computed_access_token = access_token.presence || ENV['TWITTER_ACCESS_TOKEN']
      computed_access_token_secret = access_token_secret.presence || ENV['TWITTER_ACCESS_TOKEN_SECRET']

      return if [
        computed_consumer_key,
        computed_consumer_secret,
        computed_access_token,
        computed_access_token_secret
      ].any?(&:blank?)

      client = ::Twitter::REST::Client.new do |config|
        config.consumer_key = computed_consumer_key
        config.consumer_secret = computed_consumer_secret
        config.access_token = computed_access_token
        config.access_token_secret = computed_access_token_secret
      end

      client.update(message)
    end
  end
end
