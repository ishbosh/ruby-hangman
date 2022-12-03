# frozen_string_literal: true

require_relative 'display'
require 'yaml'

# Contains methods involved in loading a save file
module LoadGame
  include DisplayText

  def load_game(filename)
    Dir.chdir('saves') do
      if File.exist?(filename)
        File.open(filename) { |f| @game_state = YAML.safe_load(f) }
      else
        show_invalid_file_error
        return nil
      end
    end
    @game_state
  end

  def save_files_list
    Dir.chdir('saves') do
      saves = Dir.glob('*.sav')
      return nil if saves.empty?

      saves
    end
  end

  def select_save_file(saves)
    save_file = nil
    until saves.include?(save_file)
      show_select_save_prompt
      save_file = gets.chomp
      save_file += '.sav' unless save_file.include?('.sav')
      puts "Selected: #{save_file}"
    end
    save_file
  end

  def delete_save_file(save_file)
    Dir.chdir('saves') do
      File.delete(save_file) if File.exist?(save_file)
    end
  end

  def load_saves
    saves = save_files_list
    if saves.nil?
      show_no_saves_error
      start_game
    else
      show_save_files(saves)
      save_file = select_save_file(saves)
      load_state(save_file)
    end
  end

  def load_state(save_file)
    game_state = load_game(save_file)
    delete_save_file(save_file)
    return intro if game_state.nil?

    @secret_word = game_state['secret_word']
    @incorrect = game_state['incorrect']
    @total_guesses = game_state['total_guesses']
    @guesses = game_state['guesses']
    @feedback = game_state['feedback']
    start_game
  end
end
