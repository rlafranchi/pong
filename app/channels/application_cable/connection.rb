module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = Player.find_by(name: 'left') 
    end

  end
end
