# frozen_string_literal: true
require './lib/maker'
require './lib/breaker'
require './lib/display'

# game flow controller
class GameController
  def initialize
    @maker = Maker.new
    @breaker = Breaker.new
    @display = Display.new
    @turns = 8
    @game_over = false
  end

  def game_loop
    @display.display_intro
    advance_turn until @game_over
  end

  def advance_turn
    # Needs to change to a display.hint method
    guess = @breaker.guess_code
    hint = @maker.hint(guess, @maker.code)
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
      p 'Breaker wins'
    elsif (out_of_turns?)
      @game_over = true
      p 'Maker wins'
    else
      @display.print_colorised_text("#{@turns} guesses remaining\n", :red)
    end
  end

  # Ask player whether to play again
  def quit?
    p 'Do you want to play again? Y / N'
    yes = 'y'
    no = 'n'
    answer = gets.chomp.downcase
    until (answer == yes || answer == no)
      p "I didn't quite catch that. Do you want to play again? Y / N"
      answer = gets.chomp.downcase
    end
    answer == no
  end
end