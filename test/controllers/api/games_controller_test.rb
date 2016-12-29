require 'test_helper'

module Api
  class GamesControllerTest < ActionDispatch::IntegrationTest
    test "GET #index" do
      get api_games_path, :xhr => true
      assert_response :success
    end

    test "POST #create" do
      assert_difference('Game.count', 1) do
        post api_games_path, :xhr => true
      end
      assert Game.last.waiting?
    end
  end
end
