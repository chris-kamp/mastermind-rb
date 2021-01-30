# frozen_string_literal: true

require './lib/display'
require './lib/maker'

# Human player or AI who tries to break the code
class Breaker
  def initialize(is_AI, input, ai_controller, display)
    @input = input
    @ai_controller = ai_controller
    @display = display
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
      guess = guess_to_int(human_turn)
    end
    @guesses.push(guess)
    guess
  end

  def prune_codes(guess)
    @guess_space.reject! { |option| option == guess }
    @code_space =
      @ai_controller.select_possible_codes(@code_space, guess, @hints.last)
  end

  # Prompt the user for a guess until valid guess received
  def human_turn
    @display.prompt_guess
    guess = @input.get_guess
    until valid_guess?(guess)
      @display.invalid_guess
      guess = @input.get_guess
    end
    guess
  end

  def guess_to_int(guess)
    guess.map { |pin| Integer(pin) }
  end

  # Receive a hint from the codemaker
  def receive_hint(hint)
    @hints.push(hint)
  end

  # Correct number of pins guessed, and all within valid range?
  def valid_guess?(guess)
    guess.is_a?(Array) && guess.all?(/[1-6]/) && guess.length == 4
  end
end
