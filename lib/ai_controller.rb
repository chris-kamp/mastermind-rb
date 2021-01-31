# frozen_string_literal: true

class AIController
  # Select a guess given hints, unused guesses and possible codes
  # using Donald Knuth's strategy: https://en.wikipedia.org/wiki/Mastermind_(board_game)#Worst_case:_Five-guess_algorithm
  def guess(hints, guess_space, code_space)
    hints.empty? ? [1, 1, 2, 2] : minmax(guess_space, code_space)
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
    possible_hints = possible_codes.map { |code| hint(guess, code) }.uniq
    initial_count = possible_codes.length
    worst_count = 0

    possible_hints.each do |hint|
      count = select_possible_codes(possible_codes, guess, hint).length
      worst_count = count if count > worst_count
    end
    initial_count - worst_count
  end

  # Given a set of codes, select only those which
  # are consistent with a given prior guess and prior hint
  def select_possible_codes(codes, last_guess, last_hint)
    codes.select { |code| hint(last_guess, code) == last_hint }
  end

  # Generate all permutations of a given length from a set of pins
  # (to find all possible codes / hints / guesses)
  def generate_permutations(pins, length)
    pins.repeated_permutation(length).to_a
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

  # Generate a code of length 4 with 6 options
  def generate_code
    code = []
    4.times { code.push rand(1..6) }
    code
  end
end
