module Api::V1
  class StocksController < ApplicationController
    def index
      render json: IEXService.stocks
    end
  end
end