class PongChannel < ApplicationCable::Channel
  def subscribed
    stream_from "pong_channel_#{params[:game_id]}"
  end
end
