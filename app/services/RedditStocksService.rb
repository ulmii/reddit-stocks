class RedditStocksService
  @logger = Logger.new($stdout)

  def self.runner
    RedditPost.find_each.each do |post|
      post.title.split.map(&:upcase).each do |word|
        next if Stock.where(symbol: word).blank?

        stock_from_db = RedditStock.where(symbol: word).first
        if stock_from_db.blank?
          reddit_stock = RedditStock.create(symbol: word, count: 1)
          reddit_stock.save
        else
          count = stock_from_db.count + 1
          stock_from_db.update(count: count)
        end
      end
    end
  end
end
