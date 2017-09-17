module Api
  class GamesController < ApplicationController
    def index
      render :json => Game.where("status != 2").order(id: :asc).limit(5).to_json({:methods => [:left_player, :right_player]})
    end

    def create
      if Game.where("status != 2").count <= 5
        render :json => Game.create
      else
        render :json => {error: "Games are limited to 5 at a time, please join an existing game."}, status: 422
      end
    end
  end
end
