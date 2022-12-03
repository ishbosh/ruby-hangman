# frozen_string_literal: true

# Contains Methods to manipulate the Dictionary of Words
module DictionaryWords
  def select_secret_word(filename)
    dictionary = File.readlines(filename)
    valid_words = dictionary.filter_map do |word|
      word.chomp.length.between?(5, 12) ? word.chomp : next
    end
    valid_words.sample
  end
end
