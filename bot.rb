require 'twitter'
require './generator'


client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
    config.access_token = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

def tweet(text)
    client.update(text)
    puts "Tweeted:\n#{text}"
end

=begin
loop do
    tweet(generate())
    sleep(30.minutes)
end
=end

tweet(generate())
