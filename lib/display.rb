# frozen_string_literal: true

# Contains methods for controlling display
class Display
  attr_reader :text_content

  SLEEP_TIME = 0.1

  def initialize
    @bg_colours = {
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
    @text_colours = {
      green: "\e[32m",
      red: "\e[31m",
      blue: "\e[34m",
      cyan: "\e[36m",
      dark_grey: "\e[90m",
    }
    @text_content = {
      guess_prompt: "\nTry to guess the code: ",
      guess_reprompt: "\nInvalid guess. Try again.\n",
      code_prompt: 'Choose a code: ',
      code_reprompt: "\nInvalid code. Try again.\n",
      play_again_prompt: "Do you want to play again? (Y / N)\n",
      play_again_reprompt:
        "\nI didn't quite catch that. Do you want to play again? (Y / N)\n",
      intro_prompt: "Do you want to see the instructions? (Y / N)\n",
      intro_reprompt:
        "\nI didn't quite catch that. Do you want to see the instructions? (Y / N)\n",
      intro: "\n\nWELCOME TO MASTERMIND\n\n------------------\n\n",
      game_start: [
        "\n------------------\nLET'S PLAY!\n------------------\n",
        "\n------------------\n\n",
      ],
      instructions: [
        "\n------------------\nINSTRUCTIONS:\n------------------\n",
        "The Codemaker selects a 4-digit code, using numbers from 1 - 6:\n",
        "(the same number can be used more than once).\n",
        "Each turn, the Codebreaker tries to guess the code by inputting 4 digits.\n" \
          "(Just type them and press enter. They can be separated by spaces, commas, or not at all.)\n",
        "Then, the Codemaker provides a hint:\n",
        "\"B\" indicates the correct digit in the correct position.\n" \
          "\"W\" indicates a correct digit, but in the wrong position.\n" \
          "\"X\" indicates an incorrect digit." \
          "Note that the hints are not in order.\n" \
          "For example, a hint of \"B\" means that you guessed one digit correctly - but it doesn't tell you which.\n",
      ],
      confirm_continue: "\nPress ENTER to continue...\n",
      winner: ["\n------------------\n", " WINS!\n------------------\n\n"],
      breaker_ai_prompt: "\nIs the Codebreaker a HUMAN PLAYER? (Y / N)\n",
      breaker_ai_reprompt:
        "\nI didn't quite catch that. Is the Codebreaker a HUMAN PLAYER? (Y / N)\n",
      maker_ai_prompt: "\nIs the Codemaker a HUMAN PLAYER? (Y / N)\n",
      maker_ai_reprompt:
        "I didn't quite catch that. Is the Codemaker a HUMAN PLAYER? (Y / N)\n",
      ai_guessing: "\nThe Codebreaker is thinking...\n",
      player_setup:
        "\n------------------\nSELECT PLAYERS\n------------------\n",
    }
  end

  # colourise a set of pins (guess or hint) and print on one line
  def print_colourised_code(code)
    colourised_code =
      code.map { |pin| "#{@bg_colours[pin]} #{pin} #{@bg_colours['neutral']}" }
    puts colourised_code.join
  end

  # Clear the preceding line
  def clear_preceding
    print "\e[A\e[2K"
  end

  # Clear the current line
  def clear_current
    print "\e[0G\e[2K"
  end

  # Set the text colour
  def set_text_colour(colour)
    print @text_colours[colour]
  end

  # Display a turn (guess followed by hint)
  def display_turn(guess, hint)
    clear_preceding
    print_colourised_text('Breaker guessed: '.ljust(25), :green)
    print_colourised_code(guess)
    print_colourised_text('Codemaker\'s hint: '.ljust(25), :green)
    print_colourised_code(hint)
  end

  # Print text with given colour
  def print_colourised_text(text, colour)
    print "#{@text_colours[colour]}#{text}#{@bg_colours['neutral']}"
  end

  def confirm_continue
    print_colourised_text(text_content[:confirm_continue], :green)
    gets
    clear_preceding
    clear_preceding
  end

  # Display game instructions
  def instructions
    print_colourised_text(text_content[:instructions][0], :green)
    confirm_continue
    print_colourised_text(text_content[:instructions][1], :green)
    print_colourised_code([1, 2, 3, 4, 5, 6])
    print_colourised_text(text_content[:instructions][2], :green)
    confirm_continue
    print_colourised_text(text_content[:instructions][3], :green)
    confirm_continue
    print_colourised_text(text_content[:instructions][4], :green)
    print_colourised_code(%w[B B W W])
    print_colourised_text(text_content[:instructions][5], :green)
    confirm_continue
  end

  # Display player setup text
  def player_setup
    print_colourised_text(text_content[:player_setup], :green)
  end

  # Display intro to the game
  def intro
    print_colourised_text(text_content[:intro], :green)
  end

  # Display game start text
  def game_start
    print_colourised_text(text_content[:game_start][0], :green)
    confirm_continue
  end

  # Display generating code text
  def generating_code
    i = 0
    4.times do
      text = 'Generating code' + ('.' * i)
      print_colourised_text(text, :green)
      sleep(SLEEP_TIME)
      clear_current
      i += 1
    end
    print_colourised_text("Code complete!\n\n", :green)
  end

  # Display game over text
  def game_over(winner)
    print_colourised_text(
      "#{text_content[:winner][0]}#{winner}#{text_content[:winner][1]}",
      :green,
    )
  end

  # Reveal the code
  def reveal_code(maker)
    print_colourised_text("The code was:\n", :green)
    maker.reveal_code
    print "\n"
  end

  # Show number of turns remaining
  def turns_remaining(turns)
    colour = Integer(turns) == 1 ? :red : :dark_grey
    noun = Integer(turns) == 1 ? 'guess' : 'guesses'
    print_colourised_text("\n#{turns} #{noun} remaining\n", colour)
  end

  # Display AI guessing text
  def ai_guessing
    print_colourised_text(text_content[:ai_guessing], :green)
  end
end
