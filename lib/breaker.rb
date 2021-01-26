# frozen_string_literal: true

require './lib/display'

# Human player or AI who tries to break the code
class Breaker
  def initialize
    @display = Display.new
  end

  def guess_code
    @display.print_colorised_text('Try to guess the code: ', :green)
    guess = sanitise_guess(gets)

    # Keep prompting until valid guess received
    until valid_guess?(guess)
      @display.print_colorised_text("Invalid guess. Try again.\n", :red)
      guess = sanitise_guess(gets)
    end

    # Convert guess to int. Note that valid_guess? should ensure this is safe.
    guess.map { |pin| Integer(pin) }
  end

  # Convert guess to array, removing comma and space separators
  def sanitise_guess(guess)
    guess.chomp.split('') - [' ', ',']
  end

  # Correct number of pins guessed, and all within valid range?
  def valid_guess?(guess)
    guess.all?(/[1-6]/) && guess.length == 4
  end
end
