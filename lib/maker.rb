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

  def hint(guess); end
end

maker = Maker.new
p maker.code
