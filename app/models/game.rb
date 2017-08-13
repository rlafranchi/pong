class Game < ApplicationRecord
  enum status: [:waiting, :playing, :over]

  has_many :players_games
  has_many :players, through: :players_games

  after_create :broadcast
  after_commit :play

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

  def data
    game_data = self.attributes
    game_data["left_player"] = left_player
    game_data["right_player"] = right_player
    game_data
  end

  def broadcast
    ActionCable.server.broadcast "games_channel", data
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

  def play
    if playing?
      PongJob.perform_later(self)
    end
  end

end
