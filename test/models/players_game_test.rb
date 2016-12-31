require 'test_helper'

module Api
  class PlayersGameTest < ActiveSupport::TestCase
    def setup
      @bob = Player.create(name: 'bob')
      @alice = Player.create(name: 'alice')
      @game = Game.create
    end
  
    test "should only have one left player" do
      pg_left = PlayersGame.create(game_id: @game.id, player_id: @bob.id, position: 'left')
      pg_double = PlayersGame.create(game_id: @game.id, player_id: @alice.id, position: 'left')
      assert_equal 1, PlayersGame.count
      assert_not_empty pg_double.errors
    end

    test "should only have one right player" do
      pg_right = PlayersGame.create(game_id: @game.id, player_id: @bob.id, position: 'right')
      pg_double = PlayersGame.create(game_id: @game.id, player_id: @alice.id, position: 'right')
      assert_equal 1, PlayersGame.count
      assert_not_empty pg_double.errors
    end

    test "should set game to playing when both have joined" do
      pg_right = PlayersGame.create(game_id: @game.id, player_id: @bob.id, position: 'right')
      pg_left = PlayersGame.create(game_id: @game.id, player_id: @alice.id, position: 'left')
      assert @game.reload.playing?
    end
  end
end
