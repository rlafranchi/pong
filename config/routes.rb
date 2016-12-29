Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, :defaults => {format: 'json'} do
    resources :games, :except => [:show, :new, :edit]
    resources :players, :only => [:create]
    resources :players_games, :only => [:create]
  end
end
