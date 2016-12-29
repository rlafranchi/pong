module Api
  class GamesController < ApplicationController
    def index
      render :json => Game.all
    end

    def create
      render :json => Game.create
    end
  end
end
