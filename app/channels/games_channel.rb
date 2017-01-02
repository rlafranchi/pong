class GamesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "games_channel"
  end
end
