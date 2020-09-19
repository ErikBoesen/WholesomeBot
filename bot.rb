require 'json'
require 'twitter'
require './generator'

credentials = JSON.parse(File.read("credentials.json"))

client = Twitter::REST::Client.new do |config|
    config.consumer_key = credentials['consumer_key']
    config.consumer_secret = credentials['consumer_secret']
    config.access_token = credentials['access_token']
    config.access_token_secret = credentials['access_token_secret']
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
