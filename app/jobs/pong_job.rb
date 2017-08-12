class PongJob < ApplicationJob
  queue_as :default

  def perform(game)
    next_hit = nil
    while game.playing?
      b = Ball.new(game, next_hit)
      b.serve
      next_hit = b.next_hit
    end
    $redis.with do |conn|
      conn.del("left:#{game.id}")
    end
    $redis.with do |conn|
      conn.del("right:#{game.id}")
    end
  end
end
