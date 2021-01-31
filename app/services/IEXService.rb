require 'httparty'

class IEXService
  @logger = Logger.new($stdout)
  OAUTH_URL = 'https://cloud.iexapis.com/beta/ref-data/symbols?token='.freeze
  @stocks = nil

  def self.stocks
    @token = load_stocks if @token == nil

    @token
  end

  private_class_method def self.load_stocks
    @logger.info('Loading stocks list')
    iex_token = ENV['IEX_TOKEN']
    stocks_url = "https://cloud.iexapis.com/beta/ref-data/symbols?token=#{iex_token}"
    response = HTTParty.get(stocks_url)
    data = JSON.parse(response.body)
    data.collect do |obj|
      obj['symbol']
    end
  end
end
