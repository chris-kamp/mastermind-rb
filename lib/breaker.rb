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

  # Get a guess from the Codebreaker (human or AI)
  def take_turn
    if @is_AI
      @display.ai_guessing
      start = Time.now
      prune_codes(@guesses.last) unless @guesses.empty?
      guess = @ai_controller.guess(@hints, @guess_space, @code_space)
      time_taken = Time.now - start
      sleep(3 - time_taken) if time_taken < 3
    else
      guess =
        @input.prompt_code(
          @display.text_content[:guess_prompt],
          @display.text_content[:guess_reprompt],
        )
    end
    @guesses.push(guess)
    guess
  end

  # Remove impossible codes and guesses that have already been taken
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
