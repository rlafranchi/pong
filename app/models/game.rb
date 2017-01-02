class Game < ApplicationRecord
  enum status: [:waiting, :playing, :over]

  has_many :players_games
  has_many :players, through: :players_games

  def left_player
    player(:left)
  end

  def right_player
    player(:right)
  end

  def score(position)
    pg = players_games.find_by(position: position)
    pg.increment(:score).save
  end

  private

  def select_stmt
    "players.id, players.name, players_games.score"
  end

  def player(position)
    Player
      .joins(:players_games)
      .select(select_stmt)
      .where(
        "players_games.game_id = ? AND players_games.position = ?",
        self.id,
        PlayersGame.positions[position]
      ).first
  end

end
