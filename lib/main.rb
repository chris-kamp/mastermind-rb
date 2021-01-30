# frozen_string_literal: true

require './lib/game_controller'

game_quit = false

until game_quit
  game_controller = GameController.new
  game_controller.game_loop
  game_quit = game_controller.quit?
end
