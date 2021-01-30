# frozen_string_literal: true

require './lib/display'
require './lib/maker'

# Human player or AI who tries to break the code
class Breaker
  def initialize(is_AI)
    @maker_sim = Maker.new
    @display = Display.new
    @is_AI = is_AI
    @hints = []
    @guesses = []
    @guess_space = generate_permutations([1, 2, 3, 4, 5, 6], 4)
    @code_space = generate_permutations([1, 2, 3, 4, 5, 6], 4)
  end

  def guess_code
    @is_AI ? ai_guess : human_guess
  end

  # Prompt for guess via stdin
  def human_guess
    @display.print_colorised_text('Try to guess the code: ', :green)
    guess = sanitise_guess(gets)

    # Keep prompting until valid guess received
    until valid_guess?(guess)
      @display.print_colorised_text("Invalid guess. Try again.\n", :red)
      guess = sanitise_guess(gets)
    end

    # Convert guess to int. Note that valid_guess? should ensure this is safe.
    guess.map { |pin| Integer(pin) }
  end

  # Generate all permutations of a given length from a set of pins
  # (to find all possible codes / hints / guesses)
  def generate_permutations(pins, length)
    pins.repeated_permutation(length).to_a
  end

  # Given a set of codes, select only those which
  # are consistent with a given prior guess and prior hint
  def select_possible_codes(codes, last_guess, last_hint)
    codes.select { |code| @maker_sim.hint(last_guess, code) == last_hint }
  end

  # Generate a guess using Donald Knuth's strategy: https://en.wikipedia.org/wiki/Mastermind_(board_game)#Worst_case:_Five-guess_algorithm
  def ai_guess
    if @hints.empty?
      next_guess = [1, 1, 2, 2]
      @guesses.push(next_guess)
      @guess_space.reject! { |guess| guess == next_guess }
      return next_guess
    end
    @code_space = select_possible_codes(@code_space, @guesses.last, @hints.last)
    next_guess = minmax(@guess_space, @code_space)
    @guess_space.reject! { |guess| guess == next_guess }
    @guesses.push(next_guess)
    next_guess
  end

  # Find the possible guess that eliminates the most code possibilities
  def minmax(guess_space, code_space)
    max_eliminated = 0
    best_guess = false
    guess_space.each do |guess|
      eliminated = calculate_min_reduction(code_space, guess)
      if eliminated > max_eliminated ||
           (eliminated == max_eliminated && code_space.include?(guess))
        max_eliminated = eliminated
        best_guess = guess
      end
    end
    best_guess
  end

  # Given a set of possible codes and a proposed guess, calculate the
  # minimum number of possible codes that guess will eliminate
  def calculate_min_reduction(possible_codes, guess)
    possible_hints =
      possible_codes.map { |code| @maker_sim.hint(guess, code) }.uniq
    initial_count = possible_codes.length
    worst_count = 0

    possible_hints.each do |hint|
      count = select_possible_codes(possible_codes, guess, hint).length
      worst_count = count if count > worst_count
    end
    initial_count - worst_count
  end

  # Receive a hint from the codemaker
  def receive_hint(hint)
    @hints.push(hint)
  end

  # Convert guess to array, removing comma and space separators
  def sanitise_guess(guess)
    guess.chomp.split('') - [' ', ',']
  end

  # Correct number of pins guessed, and all within valid range?
  def valid_guess?(guess)
    guess.all?(/[1-6]/) && guess.length == 4
  end
end
