module Api
  class PlayersController < ApplicationController
    def create
      render :json => Player.find_or_create_by(name: params[:player][:name])
    end
  end
end
