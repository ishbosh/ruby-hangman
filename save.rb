# frozen_string_literal: true

require_relative 'display'
require 'yaml'

# Contains methods involved in saving the game
module SaveGame
  include DisplayText

  def verify_save_dir_creation
    Dir.mkdir('saves') unless Dir.exist?('saves')
  end

  def check_last_save
    Dir.chdir('saves')
    saves = Dir.glob('*.sav')
    if saves[-1].nil?
      '0.sav'
    else
      saves[-1]
    end
  end

  def save_game(game_state)
    filename = (check_last_save.split('.')[0].to_i + 1).to_s
    filename = "#{filename}.sav"
    if File.exist? filename
      show_duplicate_save_error
      return nil
    end
    File.open(filename, 'w') do |f|
      YAML.dump(game_state, f)
    end
  end

  def save_state
    game_state = {
      'secret_word' => @secret_word,
      'total_guesses' => @total_guesses,
      'incorrect' => @incorrect,
      'guesses' => @guesses,
      'feedback' => @feedback
    }
    return if save_game(game_state).nil?

    show_successful_save
    exit
  end
end
