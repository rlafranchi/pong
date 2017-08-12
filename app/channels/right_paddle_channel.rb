class RightPaddleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "right_paddle_channel_#{params[:game_id]}"
  end

  def receive(data)
    $redis.with do |conn|
      conn.set("right:#{params[:game_id]}", data["y"])
    end
    ActionCable.server.broadcast "left_paddle_channel_#{params[:game_id]}", data
  end
end
