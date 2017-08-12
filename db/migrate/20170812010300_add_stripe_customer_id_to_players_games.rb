class AddStripeCustomerIdToPlayersGames < ActiveRecord::Migration[5.0]
  def change
    add_column :players_games, :stripe_customer_id, :string
  end
end
