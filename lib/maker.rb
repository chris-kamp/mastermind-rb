# frozen_string_literal: true

# Human player or AI who chooses the code
class Maker
  attr_reader :code

  def initialize(ai_controller, display)
    @display = display
    @ai_controller = ai_controller
    @code = generate_code
  end

  # generate a code of length 4 with 6 options
  def generate_code
    @ai_controller.generate_code
  end

  # Given a guess and a code, generate a hint for the guesser
  def hint(guess)
    @ai_controller.hint(guess, @code)
  end
end
