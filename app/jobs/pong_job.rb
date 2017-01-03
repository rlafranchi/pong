class PongJob < ApplicationJob
  queue_as :default

  def perform(game)
    next_hit = nil
    while game.playing?
      b = Ball.new(game, next_hit)
      b.serve
      next_hit = b.next_hit
    end
    $redis.del("left:#{game.id}")
    $redis.del("right:#{game.id}")
  end
end
