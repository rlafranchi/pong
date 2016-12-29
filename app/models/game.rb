class Game < ApplicationRecord
  enum status: [:waiting, :playing, :over]

  has_many :players_games
  has_many :players, through: :players_games

  def left_player
    pg = players_games.where(position: 'left').first
    pg.present? ? pg.player : nil
  end

  def right_player
    pg = players_games.where(position: 'right').first
    pg.present? ? pg.player : nil
  end

end
