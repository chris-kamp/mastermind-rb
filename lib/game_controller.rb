# frozen_string_literal: true
require './lib/maker'
require './lib/breaker'
require './lib/display'

# game flow controller
class GameController
  def initialize
    @maker = Maker.new
    @breaker = Breaker.new(true)
    @display = Display.new
    @turns = 8
    @game_over = false
  end

  def game_loop
    @display.display_intro
    advance_turn until @game_over
  end

  def advance_turn
    guess = @breaker.guess_code
    hint = @maker.hint(guess, @maker.code)
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
      @display.print_colorised_text(
        "\n------------------\nBREAKER WINS!\n------------------\n\n",
        :green,
      )
    elsif (out_of_turns?)
      @game_over = true
      @display.print_colorised_text(
        "\n------------------\nMAKER WINS!\n------------------\n\n",
        :green,
      )
      @display.print_colorised_text("The code was:\n", :green)
      @display.print_colorised(@maker.code)
      print "\n"
    else
      @display.print_colorised_text("#{@turns} guesses remaining\n", :red)
    end
  end

  # Ask player whether to play again
  def quit?
    @display.print_colorised_text(
      "Do you want to play again? (Y / N)\n",
      :green,
    )
    yes = 'y'
    no = 'n'
    answer = gets.chomp.downcase
    until (answer == yes || answer == no)
      @display.print_colorised_text(
        "I didn't quite catch that. Do you want to play again? (Y / N)\n",
        :green,
      )
      answer = gets.chomp.downcase
    end
    answer == no
  end
end
