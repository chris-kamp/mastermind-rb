# frozen_string_literal: true
require './lib/display'

class Input
  def initialize
    @display = Display.new
  end

  # Convert input to array, removing comma and space separators
  def input_to_arr(input)
    input.chomp.split('') - [' ', ',']
  end

  # Prompt the user for a code until valid code received
  def prompt_code
    @display.prompt_guess
    code = get_code
    until valid_code?(code)
      @display.invalid_guess
      code = get_code
    end
    code_to_ints(code)
  end

  # Get a code from the user
  def get_code
    input_to_arr(gets)
  end

  # Code is array of correct length, and all items within valid range?
  def valid_code?(code)
    code.is_a?(Array) && code.all?(/[1-6]/) && code.length == 4
  end

  # Convert code pins to integers
  def code_to_ints(code)
    code.map { |pin| Integer(pin) }
  end
end
