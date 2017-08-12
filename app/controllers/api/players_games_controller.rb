module Api
  class PlayersGamesController < ApplicationController
    def create
      players_game = PlayersGame.new(players_game_params)
      cust = StripeWrapper::Customer.create(params[:stripe_token])
      if cust.successful?
        players_game.stripe_customer_id = cust.response.id
        players_game.save
        render :json => players_game
      else
        render :json => {error: "Invalid charge authorizaiont"}, :status => :unprocessable_entity
      end
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
