module Api::V1
  class StocksController < ApplicationController
    def index
      render json: IEXService.stocks(params[:limit], params[:offset])
    end
  end
end