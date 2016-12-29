require 'test_helper'

module Api
  class PlayersGamesControllerTest < ActionDispatch::IntegrationTest
    test "POST #create" do
      player = Player.create(name: 'bob')
      game = Game.create
      assert_nil game.left_player
      assert_difference('PlayersGame.count', 1) do
        post api_players_games_path, params: {
          players_game: {
            player_id: player.id,
            game_id: game.id,
            position: 'left'
          }
        }
      end
      assert_response :success
      assert_equal player, game.left_player
      assert_equal 0, PlayersGame.last.score
    end
  end
end
