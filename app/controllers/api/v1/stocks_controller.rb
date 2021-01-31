module Api::V1
  class StocksController < ApplicationController
    def index
      render json: JSON.parse('{"test":"test"}')
    end
  end
end