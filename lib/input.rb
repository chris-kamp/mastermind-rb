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

  # Get a guess from the user
  def get_guess
    input_to_arr(gets)
  end
end
