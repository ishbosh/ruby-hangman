# frozen_string_literal: true

# Contains methods for displaying text to the console.
module DisplayText
  def show_intro
    puts "\n---------------------- Let's Play Hangman! ---------------------"
    puts "\nGuess the mystery word.\nRemaining guesses will be reduced by 1 "\
      "for every incorrect guess.\nThe word could be anything, even a name!\n "
    puts "Type 'start' to start a new game or 'load' to load a saved game.\n"
    puts '-----------------------------------------------------------------'
  end

  def show_divider
    puts '________________________________________________'
  end

  # PROMPT TEXT #
  def show_guess_prompt
    print "\nGuess a letter or word: "
  end

  # SAVE TEXT #
  def show_save_prompt
    show_divider
    puts "\nType 'save' to save your game progress and exit.\n"
  end

  def show_select_save_prompt
    print "\nType in the name of the save file to load: "
  end

  def show_successful_save
    puts "\nGame Saved Successfully. The game will now shut down."
    puts '-----------------------------------------------------'
  end

  def show_save_files(saves)
    puts "\nSAVED GAMES: "
    puts saves
  end

  # GUESS & FEEDBACK TEXT #
  def show_guesses(letters_guessed)
    print "Your guesses so far: [ #{letters_guessed.join(', ')} ]\n "
  end

  def show_guesses_remaining(total, incorrect)
    puts "\nGuesses remaining: #{total - incorrect}"
  end

  def show_feedback(feedback)
    show_divider
    puts "\n\n#{feedback}\n "
  end

  # ERROR TEXT #
  def show_invalid_file_error
    puts 'File does not exist.'
  end

  def show_duplicate_save_error
    puts "\nAbort - Save Failed. Duplicate save file found."
  end

  def show_no_saves_error
    show_divider
    puts "\nThere are no saved games. Starting a new game."
  end

  def show_intro_error
    puts "\nInvalid input. Please enter 'start' to start the game, or 'load' to load "\
    'a previously saved game.'
  end

  def show_guess_length_error(max_length)
    puts "Wrong number of letters! Guess either 1 letter or #{max_length}"
  end

  def show_guess_repeat_error(guess)
    puts "You already guessed #{guess}! Try again!\n "
  end

  def show_guess_nonalpha_error(guess)
    puts "You cannot guess #{guess}, it is not a letter or word! Try again."
  end

  # END GAME TEXT #
  def show_game_over(secret_word)
    puts "\nxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    puts "   Game Over! You are out of guesses. The word was #{secret_word}"
    puts 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  end

  def show_victory(secret_word)
    puts "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "   Congrats! You guessed the word! It was #{secret_word}"
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
  end
end
