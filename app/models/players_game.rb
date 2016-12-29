class PlayersGame < ApplicationRecord
  enum position: [:left, :right]
  belongs_to :player
  belongs_to :game
  validates :game_id, uniqueness: {scope: [:position]}
  validates :player_id, uniqueness: {scope: [:game_id]}
end
