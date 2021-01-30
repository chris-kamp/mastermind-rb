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
      guess = @input.prompt_code
    end
    @guesses.push(guess)
    guess
  end

  def prune_codes(guess)
    @guess_space.reject! { |option| option == guess }
    @code_space =
      @ai_controller.select_possible_codes(@code_space, guess, @hints.last)
  end

  # Receive a hint from the codemaker
  def receive_hint(hint)
    @hints.push(hint)
  end
end
