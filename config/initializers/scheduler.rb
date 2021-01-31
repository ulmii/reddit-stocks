require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '1s' do
  TwitterBot.tweet
end

scheduler.every '3400s' do
  RedditService.generate_token
end
