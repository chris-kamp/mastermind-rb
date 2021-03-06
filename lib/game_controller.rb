# frozen_string_literal: true
require './lib/maker'
require './lib/breaker'
require './lib/display'
require './lib/input'
require './lib/ai_controller'

# Controls the flow of a single game
class GameController
  def initialize
    @ai_controller = AIController.new
    @input = Input.new
    @display = Display.new
    @turns = 8
    @game_over = false
  end

  # Main game loop
  def game_loop
    @display.intro
    if @input.yes_no(
         @display.text_content[:intro_prompt],
         @display.text_content[:intro_reprompt],
       )
      @display.instructions
    end
    ai_settings = @input.player_setup
    @breaker =
      Breaker.new(ai_settings[:breaker], @input, @ai_controller, @display)
    @maker = Maker.new(ai_settings[:maker], @input, @ai_controller, @display)
    @display.game_start
    @maker.select_code
    advance_turn until @game_over
  end

  # Each player takes their turn
  def advance_turn
    guess = @breaker.take_turn
    hint = @maker.hint(guess)
    @breaker.receive_hint(hint)
    @display.display_turn(guess, hint)
    @turns -= 1
    post_turn(hint)
  end

  def out_of_turns?
    @turns == 0
  end

  def breaker_won?(hint)
    hint == %w[B B B B]
  end

  # When a turn is complete, check if game is over
  def post_turn(hint)
    if (breaker_won?(hint))
      @game_over = true
      @display.game_over('BREAKER')
    elsif (out_of_turns?)
      @game_over = true
      @display.game_over('MAKER')
      @display.reveal_code(@maker)
    else
      @display.turns_remaining(@turns)
    end
  end

  # Ask player whether to play again
  def quit?
    @input.yes_no(
      @display.text_content[:play_again_prompt],
      @display.text_content[:play_again_reprompt],
    ) == false
  end
end
