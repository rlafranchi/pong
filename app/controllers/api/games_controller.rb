module Api
  class GamesController < ApplicationController
    def index
      render :json => Game.all.to_json({:methods => [:left_player, :right_player]})
    end

    def create
      render :json => Game.create
    end
  end
end
