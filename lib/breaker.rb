# frozen_string_literal: true

require './lib/display'
require './lib/maker'

# Human player or AI who tries to break the code
class Breaker
  def initialize(is_AI, input, ai_controller)
    @input = input
    @ai_controller = ai_controller
    @display = Display.new
    @is_AI = is_AI
    @hints = []
    @guesses = []
    @guess_space = @ai_controller.generate_permutations([1, 2, 3, 4, 5, 6], 4)
    @code_space = @ai_controller.generate_permutations([1, 2, 3, 4, 5, 6], 4)
  end

  def take_turn
    if @is_AI
      prune_codes(@guesses.last) unless @guesses.empty?
      guess = @ai_controller.guess(@hints, @guess_space, @code_space)
    else
      guess = human_guess
    end
    @guesses.push(guess)
    guess
  end

  def prune_codes(guess)
    @guess_space.reject! { |option| option == guess }
    @code_space =
      @ai_controller.select_possible_codes(@code_space, guess, @hints.last)
  end

  # Prompt for guess via stdin
  def human_guess
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

  # Receive a hint from the codemaker and prune possible codes accordingly
  def receive_hint(hint)
    @hints.push(hint)
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
