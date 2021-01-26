# frozen_string_literal: true

# Contains methods for controlling display
class Display
  # to do

  def initialize
    @colour_codes = {
      1 => "\e[41m", # Red
      2 => "\e[42m", # Green
      3 => "\e[43m\e[90m", # Yellow with dark grey text
      4 => "\e[44m", # Blue
      5 => "\e[45m", # Magenta
      6 => "\e[46m", # Cyan
      'B' => "\e[100m", # Dark grey
      'W' => "\e[107m\e[30m", # White with black text
      'neutral' => "\e[0m", # Reset
    }
    @text_colours = { green: "\e[32m", red: "\e[31m" }
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

  # Clear the preceding line (which should be user input)
  def clear_preceding
    print "\e[A\e[2K"
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
end
