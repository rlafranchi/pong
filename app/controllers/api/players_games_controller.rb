module Api
  class PlayersGamesController < ApplicationController
    def create
      players_game = PlayersGame.new(players_game_params)
      players_game.save!
      render :json => players_game
    end

    private

    def players_game_params
      params.require(:players_game).permit(
        :game_id,
        :player_id,
        :position,
        :score
      )
    end
  end
end
