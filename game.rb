# frozen_string_literal: true

require_relative 'display'
require_relative 'words'
require_relative 'save'
require_relative 'load'

# Container for the hangman game
module Hangman
  # Includes all game logic and data
  class Game
    include DictionaryWords
    include DisplayText
    include SaveGame
    include LoadGame

    def initialize
      @display = Display.new
      @secret_word = select_secret_word('google-10000-english.txt')
      @total_guesses = [@secret_word.length, 8].min
      @incorrect = 0
      @guesses = []
      blanks = ('_' * @secret_word.length).strip
      @feedback = blanks.chars.join(' ')
      @game_ended = false
      intro
    end

    def intro
      verify_save_dir_creation
      show_intro
      input_start_state
    end

    def input_start_state
      start_state = nil
      valid_starts = %w[load start]
      until valid_starts.include?(start_state)
        start_state = gets.chomp.downcase
        @display.error_text('intro') unless valid_starts.include?(start_state)
      end
      start_state(start_state)
    end

    def start_state(start_state)
      case start_state
      when 'start'
        start_game
      when 'load'
        load_saves
      end
    end

    def start_game
      play until @game_ended
    end

    def play
      @display.play_text(@feedback, @total_guesses, @incorrect, @guesses)
      guess = player_guess
      update_feedback(guess)
      @game_ended = game_end?
    end

    def player_guess
      guess = nil
      guess = input_guess(@secret_word.length) until guess.nil? == false
      guess
    end

    def input_guess(max_length)
      @display.guess_prompt_text
      input = gets.chomp.strip.downcase
      save_state if input.eql?('save')
      return nil unless valid_guess?(input, max_length)

      @guesses << input
      input
    end

    def update_feedback(guess)
      if correct_guess?(guess)
        char_indexes = find_correct_char_indexes(guess)
        @feedback = add_correct_char(char_indexes)
      else
        @incorrect += 1
      end
    end

    def valid_guess?(guess, max_length)
      error = 'nonalpha' if guess.match?(/[^a-z]/)
      error = 'repeat' if @guesses.include?(guess)
      error = 'length' if guess.length != 1 && guess.length != max_length
      return true if error.nil?

      @display.error_text(error)
    end

    def correct_guess?(guess)
      @secret_word.include?(guess)
    end

    def find_correct_char_indexes(guess)
      @secret_word.chars.each_with_index.filter_map do |letter, index|
        index if letter == guess[index] || letter == guess
      end
    end

    def add_correct_char(char_indexes)
      feedback_array = @feedback.split(' ')
      char_indexes.each do |index|
        feedback_array[index] = @secret_word[index]
      end
      feedback_array.join(' ')
    end

    def game_end?
      if @feedback.split(' ').join == @secret_word
        @display.victory_text(@secret_word)
      elsif @incorrect == @total_guesses
        @display.loss_text(@secret_word)
      else
        return false
      end
      true
    end
  end

  # Methods for displaying to console
  class Display
    include DisplayText

    def play_text(feedback, total, incorrect, guesses)
      show_save_prompt
      show_feedback(feedback)
      show_guesses_remaining(total, incorrect)
      show_guesses(guesses)
    end

    def guess_prompt_text
      show_guess_prompt
    end

    def victory_text(secret_word)
      show_victory(secret_word)
    end

    def loss_text(secret_word)
      show_game_over(secret_word)
    end

    def error_text(error, guess = nil, max_length = nil)
      case error
      when 'intro'
        show_intro_error
      when 'nonalpha'
        show_guess_nonalpha_error(guess)
      when 'repeat'
        show_guess_repeat_error(guess)
      when 'length'
        show_guess_length_error(max_length)
      end
    end
  end

  Game.new
end
