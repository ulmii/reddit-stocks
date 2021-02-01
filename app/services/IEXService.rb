require 'httparty'

class IEXService
  @logger = Logger.new($stdout)
  OAUTH_URL = 'https://cloud.iexapis.com/beta/ref-data/symbols?token='.freeze
  @stocks = nil

  def self.stocks(limit = 25, offset = 0)
    Stock.all.limit(limit).offset(offset)
  end

  def self.load_stocks
    @logger.info('Loading stocks list')
    iex_token = ENV['IEX_TOKEN']
    stocks_url = "https://cloud.iexapis.com/beta/ref-data/symbols?token=#{iex_token}"
    response = HTTParty.get(stocks_url)
    data = JSON.parse(response.body)
    data.collect do |obj|
      obj['symbol']
    end
  end

  def self.save_stocks(stocks)
    stocks.each do |stock|
      if Stock.where(symbol: stock).blank?
        symbol = Stock.create(symbol: stock)
        symbol.save
      end
    end
  end

  def self.runner
    stocks = load_stocks
    save_stocks(stocks)
  end

  class << self
    private :load_stocks
    private :save_stocks
  end
end
