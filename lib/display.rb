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
  end

  def colorise_output(pins_array)
    pins_array.map do |pin|
      "#{@colour_codes[pin]} #{pin} #{@colour_codes['neutral']}"
    end
  end

  def print_colorised(pins_array)
    puts colorise_output(pins_array).join
  end

