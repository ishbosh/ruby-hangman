require_relative 'display'

module Hangman
  class Game
    include DisplayText

    def initialize
      @secret_word = select_secret_word
      @TOTAL_GUESSES = [@secret_word.length, 8].min.freeze
      @incorrect_guesses = 0
      blanks = ('_' * @secret_word.length).strip
      @feedback = blanks.chars.join(' ')
      @game_ended = false
      @letters_guessed = []
      game_loop
    end

    def select_secret_word
      # Load in the dictionary
      dictionary = File.readlines('google-10000-english.txt')
      # Select a random word between 5 and 12 characters long for the secret word
      valid_words = dictionary.filter_map do |word|
        word.chomp.length.between?(5, 12) ? word.chomp : next
      end
      valid_words.sample
    end

    def play
      show_feedback(@feedback)
      if @feedback.split(' ').join == @secret_word
        show_victory(@secret_word, @feedback)
        @game_ended = true
      elsif @incorrect_guesses == @TOTAL_GUESSES
        show_game_over(@secret_word)
        @game_ended = true
      else
        guess = input_guess(@secret_word.length)
      end
      if @game_ended
        return
      elsif correct_guess?(guess)
        char_indexes = find_correct_char_indexes(guess)
        @feedback = add_correct_char(char_indexes)
      else
        @incorrect_guesses += 1
      end
      show_guesses_remaining(@TOTAL_GUESSES, @incorrect_guesses)
      show_guesses(@letters_guessed)
    end

    def game_loop
      play until @game_ended
    end

    def find_correct_char_indexes(guess)
      @secret_word.chars.each_with_index.filter_map do |letter, index|
        index if letter == guess[index] || letter == guess
      end
    end
    
    def input_guess(max_length)
      show_guess_prompt
      guess = gets.chomp.downcase
      if guess.match?(/[^a-z]/)
        show_guess_nonalpha_error(guess)
        input_guess(max_length)
      elsif @letters_guessed.include?(guess)
        show_guess_repeat_error(guess)
        input_guess(max_length)
      elsif guess.length == 1 || guess.length == max_length
        @letters_guessed << guess
        guess
      else
        show_guess_length_error(max_length)
        input_guess(max_length)
      end
    end
    
    def correct_guess?(guess)
      @secret_word.include?(guess)
    end
    
    def add_correct_char(char_indexes)
      char_indexes
      feedback_array = @feedback.split(' ')
      char_indexes.each do |index|
        feedback_array[index] = @secret_word[index]
      end
      feedback_array.join(' ')
    end
  end

  Game.new
end