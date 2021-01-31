require 'httparty'

class RedditService
  @logger = Logger.new($stdout)

  OAUTH_URL = 'https://www.reddit.com/api/v1/access_token'.freeze
  @token = nil

  def self.token
    @token = generate_token if @token == nil

    @token
  end

  private_class_method def self.generate_token
    @logger.info('Generating new reddit access token')

    reddit_username = ENV['REDDIT_USER']
    reddit_password = ENV['REDDIT_PASSWORD']
    reddit_client_id = ENV['REDDIT_CLIENT_ID']
    reddit_client_secret = ENV['REDDIT_SECRET']

    json = HTTParty.post(OAUTH_URL, headers: {
      'User-Agent': 'RedditStocks/0.1 by Ulmii'
    },
                         body: {
                           grant_type: 'password',
                           username: reddit_username,
                           password: reddit_password,
                         },
                         basic_auth: {
                           username: reddit_client_id,
                           password: reddit_client_secret
                         })

    @token = JSON.parse(json.body)['access_token']
  end
end
