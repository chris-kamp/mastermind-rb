# frozen_string_literal: true

require './lib/game_controller'

game_quit = false

# until game_quit
#   game_controller = GameController.new
#   game_controller.main_loop
#   # p 'Replay? y / n'
#   # game_quit = true unless gets.chomp.downcase == 'y'
# end
until game_quit
  game_controller = GameController.new
  game_controller.game_loop
  game_quit = game_controller.quit?
end
