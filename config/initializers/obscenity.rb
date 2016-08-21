unpluralized_bad_words_array = ENV["BAD_WORDS"].downcase().split(" ")
bad_words_array = Array.new
unpluralized_bad_words_array.each do |bad_word|
  bad_words_array << bad_word
  bad_words_array << bad_word.pluralize(2)
end

Obscenity.configure do |config|
  config.blacklist = bad_words_array
  config.replacement = :vowels
end
