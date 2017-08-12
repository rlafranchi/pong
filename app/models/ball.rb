class Ball
  attr_reader :next_hit
  TABLE_WIDTH = 650
  TABLE_HEIGHT = 480
  BALL_HEIGHT = 15
  BALL_WIDTH = 15
  PADDLE_HEIGHT = 80
  VALID_SLOPES = [0, 0.0875, 0.2679, 0.5773, 1]

  def initialize(game, next_hit=nil)
    @game = game
    @difficulty = 5
    @x = 318
    @y = 232
    next_hit ||= 'left'
    @next_hit = next_hit
    @direction_x = nil
    @direction_y = nil
  end

  def serve
    @direction_x = @next_hit == 'left' ? -1 : 1
    @direction_y = VALID_SLOPES.sample
    Rails.logger.debug "DIRECTION: #{@direction_y}"
    if [true, false].sample
      @direction_y = -@direction_y
    end
    loop do
      broadcast
      update
      break if point_scored?
      sleep 0.01
    end
    tally
  end

  private

  def update
    if next_y >= top_y || next_y <= bottom_y
      @direction_y = -@direction_y
    end
    deflect if will_hit?
    @x += (@difficulty * @direction_x)
    @y += (@difficulty * @direction_y)
  end

  def point_scored?
    @x <= left_goal_x || @x >= right_goal_x
  end

  def will_hit?
    upper_paddle = next_paddle_y + PADDLE_HEIGHT + BALL_HEIGHT
    top_of = point_of_contact + BALL_HEIGHT
    ((next_x <= left_deflection_x && @x > left_deflection_x) ||
    (next_x >= right_deflection_x && @x < right_deflection_x)) &&
    (top_of >= next_paddle_y && top_of <= upper_paddle)
  end

  def point_of_contact
    delta_x = paddle_x - @x
    delta_y = @direction_y * delta_x
    @y + delta_y
  end

  def deflect
    poc = point_of_contact
    @x = paddle_x
    @y = poc
    relative_point = poc + (BALL_HEIGHT / 2) - (PADDLE_HEIGHT / 2) - next_paddle_y
    slope_index = (relative_point).abs.ceil
    slope_index = slope_index > 4 ? 4 : slope_index
    @direction_y = VALID_SLOPES[slope_index]
    @direction_y = relative_point < 0 ? -@direction_y : @direction_y
    @direction_x = -@direction_x
    Rails.logger.debug "DEFLECT...."
    Rails.logger.debug "contact: #{poc}"
    Rails.logger.debug "relative: #{relative_point}"
    Rails.logger.debug "paddle: #{next_paddle_y}"
    toggle_next_hit
  end

  def next_y
    @y + (@difficulty * @direction_y)
  end

  def next_x
    @x + (@difficulty * @direction_x)
  end

  def toggle_next_hit
    @next_hit = @next_hit == 'left' ? 'right' : 'left'
  end

  def next_paddle_y
    @next_hit == 'left' ? left_paddle_y : right_paddle_y
  end

  def left_paddle_y
    result = 200
    $redis.with do |conn|
      result = conn.get("left:#{@game.id}").to_i || result
    end
    return result
  end

  def right_paddle_y
    result = 200
    $redis.with do |conn|
      result = conn.get("right:#{@game.id}").to_i || result
    end
    return result
  end

  def paddle_x
    @next_hit == 'left' ? left_deflection_x : right_deflection_x
  end

  def left_goal_x
    0 - BALL_WIDTH
  end

  def right_goal_x
    TABLE_WIDTH
  end

  def left_deflection_x
    BALL_WIDTH * 3
  end

  def right_deflection_x
    TABLE_WIDTH - (BALL_WIDTH * 4)
  end

  def bottom_y
    0
  end

  def top_y
    TABLE_HEIGHT - BALL_HEIGHT
  end

  def tally
    toggle_next_hit
    @game.score(@next_hit)
    @game.reload
  end

  def broadcast
    ActionCable.server.broadcast "pong_channel_#{@game.id}", { x: @x, y: @y }
  end
end
