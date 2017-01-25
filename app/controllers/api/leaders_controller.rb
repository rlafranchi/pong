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
               count(pg.id) total_games,
               sum(case when pg.score = 10 then 1 else 0 end) games_won
        FROM players p
        LEFT JOIN players_games pg on pg.player_id = p.id
        GROUP BY p.name
        ORDER BY sum(case when pg.score = 10 then 1 else 0 end) DESC, count(pg.id) ASC, sum(pg.score) DESC
        LIMIT 5
      })
    end
  end
end
