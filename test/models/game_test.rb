require 'test_helper'

class GameTest < ActionDispatch::IntegrationTest
  def setup
    @game = Game.create
    bob = Player.create(name: 'bob')
    alice = Player.create(name: 'alice')
    @pg_left = PlayersGame.create(game_id: @game.id, player_id: bob.id, position: 'left')
    @pg_right = PlayersGame.create(game_id: @game.id, player_id: alice.id, position: 'right')
    @game.reload
    assert @game.playing?
  end

  test "#score left" do
    @game.score('left')
    assert_equal 1, @pg_left.reload.score
  end

  test "#score right" do
    @game.score('right')
    assert_equal 1, @pg_right.reload.score
  end

  test "#score end game" do
    10.times do
      @game.score('right')
    end
    assert_equal 10, @pg_right.reload.score
    assert @game.reload.over?
  end
end
