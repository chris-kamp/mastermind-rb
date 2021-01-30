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
  def prompt_code(is_guess)
    is_guess ? @display.prompt_guess : @display.prompt_code
    code = get_code
    until valid_code?(code)
      is_guess ? @display.invalid_guess : @display.invalid_code
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
