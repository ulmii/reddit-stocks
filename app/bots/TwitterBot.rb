class TwitterBot
  @logger = Logger.new(STDOUT)

  def self.tweet
    @logger.info('tweet')
  end
end