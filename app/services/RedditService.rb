require 'httparty'
require 'ostruct'

class RedditService
  @logger = Logger.new($stdout)

  OAUTH_URL = 'https://www.reddit.com/api/v1/access_token'.freeze
  WALL_STREET_URL = 'https://oauth.reddit.com/r/wallstreetbets/hot?'.freeze
  @token = nil

  def self.posts(limit = 25, after = nil)
    request_url = WALL_STREET_URL + "&limit=#{limit}"
    request_url += "&after=#{after}" unless after.nil?

    response = HTTParty.get(request_url, headers: {
      'Authorization': "Bearer #{token}",
      'User-Agent': 'RedditStocks/0.1 by Ulmii'
    })

    parsed_data = JSON.parse(response.body)['data']['children']

    parsed_data.collect do |obj|
      parsed_post = obj['data']
      OpenStruct.new({ name: parsed_post['name'], title: parsed_post['title'], selftext: parsed_post['selftext'] })
    end
  end

  def self.token
    @token = generate_token if @token == nil

    @token
  end

  def self.runner
    posts_loaded = FALSE
    after = nil
    limit = 25
    while posts_loaded == FALSE
      posts = self.posts(limit, after)
      after = posts[-1].name
      posts_loaded = save_posts(posts)
      limit = 100 unless posts_loaded
    end
  end

  private_class_method def self.save_posts(posts)
    old_batch = TRUE
    posts.each do |post|
      if RedditPost.where(name: post.name).blank?
        post = RedditPost.create(name: post.name, title: post.title, selftext: post.selftext)
        post.save
        old_batch = FALSE
      else
        old_batch = TRUE
      end
    end

    old_batch
  end

  private_class_method def self.generate_token
    @logger.info('Generating new reddit access token')

    reddit_username = ENV['REDDIT_USER']
    reddit_password = ENV['REDDIT_PASSWORD']
    reddit_client_id = ENV['REDDIT_CLIENT_ID']
    reddit_client_secret = ENV['REDDIT_SECRET']

    response = HTTParty.post(OAUTH_URL, headers: {
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

    @token = JSON.parse(response.body)['access_token']
  end
end
