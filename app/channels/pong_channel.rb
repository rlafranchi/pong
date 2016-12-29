class PongChannel < ApplicationCable::Channel
  def subscribed
    stream_from "pong_channel"
  end

  def receive(data)
    ActionCable.server.broadcast "pong_channel", data
  end
end
