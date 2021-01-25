# frozen_string_literal: true

# Human player or AI who tries to break the code
class Breaker
  def guess_code
    puts 'Try to guess the code: '
    guess = sanitise_guess(gets)

    # Keep prompting until valid guess received
    until valid_guess?(guess)
      puts "Invalid guess. Try again.\n"
      guess = sanitise_guess(gets)
    end

    # Convert guess to int. Note that valid_guess? should ensure this is safe.
    guess.map { |pin| Integer(pin) }
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
