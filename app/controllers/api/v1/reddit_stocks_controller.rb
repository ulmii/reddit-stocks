module Api::V1
  class RedditStocksController < ApplicationController
    def index
      render json: RedditStocksService.reddit_stocks(params[:limit], params[:offset])
    end
  end
end