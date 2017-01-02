class PongJob < ApplicationJob
  queue_as :default

  def perform(game)
    while game.playing?
      b = Ball.new(game)
      b.serve
    end
  end
end
