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
  def prompt_code(prompt, reprompt)
    @display.print_colorised_text(prompt, :green)
    code = get_code
    until valid_code?(code)
      @display.print_colorised_text(reprompt, :red)
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

  # Ask the player a yes or no question
  def yes_no(prompt, reprompt)
    keys = { yes: 'y', no: 'n' }
    @display.print_colorised_text(prompt, :green)
    answer = gets.chomp.downcase
    until (answer == keys[:yes] || answer == keys[:no])
      @display.print_colorised_text(reprompt, :red)
      answer = gets.chomp.downcase
    end
    answer == keys[:yes]
  end

  def player_setup
    breaker_ai =
      yes_no(
        @display.text_content[:breaker_ai_prompt],
        @display.text_content[:breaker_ai_reprompt],
      )
    maker_ai =
      yes_no(
        @display.text_content[:maker_ai_prompt],
        @display.text_content[:maker_ai_reprompt],
      )
    { breaker: !breaker_ai, maker: !maker_ai }
  end
end
