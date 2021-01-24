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

  def hint(guess, code)
    hint = []
    remaining_guesses = []
    remaining_code = []
    guess.each_with_index do |pin, index|
      if pin == code[index]
        hint.push('B')
      else
        remaining_guesses.push(pin)
        remaining_code.push(code[index])
      end
    end
    remaining_guesses.each do |guess_item|
      if remaining_code.include?(guess_item)
        hint.push('W')
        remaining_code.slice!(remaining_code.index(guess_item))
      end
    end
    hint
  end
end

# maker = Maker.new
# p maker.code
