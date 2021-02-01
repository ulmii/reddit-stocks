require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

# TODO: Add twitter support
# scheduler.every '1s' do
#   TwitterBot.tweet
# end

scheduler.every '3400s' do
  RedditService.generate_token
end

scheduler.every '30m' do
  RedditService.runner
end

scheduler.every '1d' do
  IEXService.runner
  RedditStocksService.runner
end