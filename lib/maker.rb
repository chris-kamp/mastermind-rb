# frozen_string_literal: true

# Human player or AI who chooses the code
class Maker
  def initialize(is_AI, input, ai_controller, display)
    @is_AI = is_AI
    @input = input
    @ai_controller = ai_controller
    @display = display
    @code = []
  end

  # Get a code from the AI or the human player
  def select_code
    if @is_AI
      @display.generating_code
      @code = @ai_controller.generate_code
    else
      @code = human_select_code
    end
  end

  # Allow a human player to select a code
  def human_select_code
    @input.prompt_code(
      @display.text_content[:code_prompt],
      @display.text_content[:code_reprompt],
    )
  end

  # Given a guess and a code, generate a hint for the guesser
  def hint(guess)
    @ai_controller.hint(guess, @code)
  end

  # Reveal the code
  def reveal_code
    @display.print_colourised_code(@code)
  end
end
