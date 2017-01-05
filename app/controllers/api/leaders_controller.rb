module Api
  class LeadersController < ApplicationController
    def index
      render :json => leader_board
    end

    private

    def leader_board
      Player.find_by_sql(%q{
        SELECT p.name,
               sum(pg.score) points,
               count(pg.id) as total_games,
               (SELECT count(pg1.id)
                FROM players_games pg1
                WHERE pg1.player_id = p.id
                AND pg1.score = 10
               ) as games_won
        FROM players p
        LEFT JOIN players_games pg on pg.player_id = p.id
        GROUP BY p.name
        ORDER BY p.name
      })
    end
  end
end
