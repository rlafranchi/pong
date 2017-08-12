class LeftPaddleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "left_paddle_channel_#{params[:game_id]}"
  end

  def receive(data)
    $redis.with do |conn|
      conn.set("left:#{params[:game_id]}", data["y"])
    end
    ActionCable.server.broadcast "right_paddle_channel_#{params[:game_id]}", data
  end
end
