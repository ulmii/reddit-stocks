module Api::V1
  class StocksController < ApplicationController
    def index
      StocksService.call(params[:message])
      render json: JSON.parse('{"test":"test"}')
    end
  end
end