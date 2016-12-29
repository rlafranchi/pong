class PlayersGame < ApplicationRecord
  enum position: [:left, :right]
  belongs_to :player
  belongs_to :game
end
