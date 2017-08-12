class PlayersGame < ApplicationRecord
  enum position: [:left, :right]
  belongs_to :player
  belongs_to :game
  validates :game_id, uniqueness: {scope: [:position]}
  validates :player_id, uniqueness: {scope: [:game_id]}

  after_save :update_game
  after_commit :broadcast_game

  private

  def update_game
    if game.waiting? && game.players_games.count == 2
      game.playing!
    elsif game.playing? && score >= 10
      game.over!
    end
  end

  def broadcast_game
    game.broadcast
  end
end
