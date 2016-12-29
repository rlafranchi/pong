class CreatePlayersGames < ActiveRecord::Migration[5.0]
  def change
    create_table :players_games do |t|
      t.integer :game_id
      t.integer :player_id
      t.integer :position
      t.integer :score, :default => 0, :limit => 1
    end

    add_foreign_key :players_games, :players
    add_foreign_key :players_games, :games
  end
end
