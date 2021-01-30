# frozen_string_literal: true

# Contains methods for controlling display
class Display
  SLEEP_TIME = 0.1

  def initialize
    @colour_codes = {
      1 => "\e[41m", # Red
      2 => "\e[42m", # Green
      3 => "\e[43m\e[90m", # Yellow with dark grey text
      4 => "\e[44m", # Blue
      5 => "\e[45m", # Magenta
      6 => "\e[46m", # Cyan
      'B' => "\e[40m", # Black
      'W' => "\e[107m\e[30m", # White with black text
      'X' => "\e[100m", # Dark grey
      'neutral' => "\e[0m", # Reset
    }
    @text_colours = { green: "\e[32m", red: "\e[31m" }
  end

  # Prompt player to input a guess
  def prompt_guess
    print_colorised_text('Try to guess the code: ', :green)
  end

  # Report invalid guess
  def invalid_guess
    print_colorised_text("Invalid guess. Try again.\n", :red)
  end

  # Prompt player to input a code
  def prompt_code
    print_colorised_text('Choose a code: ', :green)
  end

  # Report invalid code
  def invalid_code
    print_colorised_text("Invalid code. Try again.\n", :red)
  end

  # Colorise a set of pins (guess or hint)
  def colorise_output(pins_array)
    pins_array.map do |pin|
      "#{@colour_codes[pin]} #{pin} #{@colour_codes['neutral']}"
    end
  end

  # Colorise a set of pins (guess or hint) and print on one line
  def print_colorised(pins_array)
    puts colorise_output(pins_array).join
  end

  # Clear the preceding line
  def clear_preceding
    print "\e[A\e[2K"
  end

  # Clear the current line
  def clear_current
    print "\e[0G\e[2K"
  end

  # Display a turn (guess followed by hint)
  def display_turn(guess, hint)
    clear_preceding
    print_colorised_text('Breaker guessed: '.ljust(25), :green)
    print_colorised(guess)
    print_colorised_text('Codemaker\'s hint: '.ljust(25), :green)
    print_colorised(hint)
  end

  # Print text with given colour
  def print_colorised_text(text, colour)
    print "#{@text_colours[colour]}#{text}#{@colour_codes['neutral']}"
  end

  def confirm_continue
    print_colorised_text("\nPress ENTER to continue...\n", :green)
    gets
    clear_preceding
    clear_preceding
  end

  # Display intro to the game
  def display_intro
    print_colorised_text(
      "\n\nWELCOME TO MASTERMIND\n\n------------------\n\n",
      :green,
    )
    confirm_continue
    print_colorised_text("INSTRUCTIONS:\n", :green)
    confirm_continue
    print_colorised_text(
      "The Codemaker selects a 4-digit code, using numbers from 1 - 6:\n",
      :green,
    )
    print_colorised([1, 2, 3, 4, 5, 6])
    print_colorised_text(
      "(the same number can be used more than once).\n",
      :green,
    )
    confirm_continue
    print_colorised_text(
      "Each turn, the Codebreaker tries to guess the code by inputting 4 digits.\n" \
        "(Just type them and press enter. They can be separated by spaces, commas, or not at all.)\n",
      :green,
    )
    confirm_continue
    print_colorised_text("Then, the Codemaker provides a hint:\n", :green)
    print_colorised(%w[B B W W])
    print_colorised_text(
      "\"B\" indicates the correct digit in the correct position.\n" \
        "\"W\" indicates a correct digit, but in the wrong position.\n" \
        "But remember, the hints are not in order.\n" \
        "For example, a hint of \"B\" means that you guessed one digit correctly - but it doesn't tell you which.",
      :green,
    )
    confirm_continue
    print_colorised_text("\nARE YOU READY TO PLAY?\n\n", :green)
    confirm_continue
    print_colorised_text("\n------------------\n\n", :green)
    print_colorised_text('Generating code', :green)
    sleep(SLEEP_TIME)
    clear_current
    print_colorised_text('Generating code.', :green)
    sleep(SLEEP_TIME)
    clear_current
    print_colorised_text('Generating code..', :green)
    sleep(SLEEP_TIME)
    clear_current
    print_colorised_text('Generating code...', :green)
    sleep(SLEEP_TIME)
    clear_current
    print_colorised_text("Code complete!\n\n", :green)
  end
end
