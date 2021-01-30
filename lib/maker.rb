# frozen_string_literal: true

# Human player or AI who chooses the code
class Maker
  attr_reader :code

  def initialize
    @code = generate_code
  end

  # generate a code of length 4 with 6 options
  def generate_code
    code = []
    4.times { code.push rand(1..6) }
    code
  end

  # Given a guess and a code, generate a hint for the guesser
  def hint(guess, code)
    hint = []
    unmatched_guesses = []
    unmatched_code = []

    guess.each_with_index do |pin, index|
      if pin == code[index]
        hint.push('B')
      else
        unmatched_guesses.push(pin)
        unmatched_code.push(code[index])
      end
    end
    unmatched_guesses.each do |pin|
      if unmatched_code.include?(pin)
        hint.push('W')
        unmatched_code.slice!(unmatched_code.index(pin))
      end
    end
    (4 - hint.length).times { hint.push 'X' }
    hint
  end
end
