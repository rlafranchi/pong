module Api
  class PlayersController < ApplicationController
    def create
      player = Player.find_or_create_by(name: params[:player][:name])
      if player.valid?
        render :json => player
      else
        render :json => {:errors => player.errors.full_messages}, :status => 422
      end
    end
  end
end
