require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  test "POST #create" do
    assert_difference('Player.count', 1) do
      post api_players_path, params: {
        player: {
          name: 'bob'
        }
      }
    end
    assert_response :success
  end

  test "POST #create twice" do
    assert_difference('Player.count', 1) do
      post api_players_path, params: {
        player: {
          name: 'bob'
        }
      }
    end
    assert_difference('Player.count', 0) do
      post api_players_path, params: {
        player: {
          name: 'bob'
        }
      }
    end
    assert_response :success
  end
end
