class PagesController < ApplicationController
  def home

  end

  def analysis
    @valid_input = false
    @song = params[:song]
    @artist = params[:artist]

    if !@song.nil? && !@artist.nil?
      begin
        fetcher = Lyricfy::Fetcher.new
        song = fetcher.search @artist.downcase(), @song.downcase()

        if !song.nil?
          @valid_input = true
          @lyrics = song.body.gsub("\\n", '<br>') # lyrics separated by '\n'
          @isolated_bad_lines, @highlighted_lyrics = isolated_bad_lines(@lyrics)
          @sfw = @isolated_bad_lines.empty?

          @uniq_isolated_bad_lines = Hash.new
          @isolated_bad_lines.each do |bad_word, bad_lines|
            @uniq_isolated_bad_lines[bad_word] = Array.new
            bad_lines.uniq.each do |uniq_line|
              @uniq_isolated_bad_lines[bad_word] << uniq_line
            end
          end
          puts @uniq_isolated_bad_lines
        end
      rescue
        @error_notice = "You had some invalid input there! Let's try that again."
      end
    else
      @error_notice = "You need some input!"
    end

    @error_notice = "You had some invalid input there! Let's try that again."
  end

  private
    def isolated_bad_lines(lyrics)
      unpluralized_bad_words_array = ENV["BAD_WORDS"].downcase().split(" ")
      bad_words_array = Array.new
      unpluralized_bad_words_array.each do |bad_word|
        bad_words_array << bad_word
        bad_words_array << bad_word.pluralize(2)
      end

      lyrics_array = lyrics.split("<br>")
      highlighted_lyrics_array = lyrics.split("<br>")
      bad_lines = Hash.new
      cleaned_line = nil
      puts "Bad words: #{bad_words_array}"

      lyrics_array.length.times do |line_num|
        bad_words_array.each do |bad_word|
          if (lyrics_array[line_num].downcase().split(" ").include? bad_word)
            if cleaned_line.nil?
              cleaned_line = lyrics_array[line_num].gsub(bad_word.humanize, bad_word.humanize.tr('aeiouAEIOU', '*')).gsub(bad_word, bad_word.tr('aeiouAEIOU', '*'))
            else
              cleaned_line = cleaned_line.gsub(bad_word.humanize, bad_word.humanize.tr('aeiouAEIOU', '*')).gsub(bad_word, bad_word.tr('aeiouAEIOU', '*'))
            end

            if bad_lines[bad_word]
              bad_lines[bad_word] << Obscenity.sanitize(cleaned_line)
            else
              bad_lines[bad_word] = Array.new << Obscenity.sanitize(cleaned_line)
            end

            # puts "bad line with #{bad_word.tr('aeiouAEIOU', '*')} found: #{cleaned_line}"
          end
        end # END bad_words_array.each

        if !cleaned_line.nil?
          highlighted_lyrics_array[line_num] = "<mark class='bad-line-highlight'>#{cleaned_line}</mark>"
        else
          highlighted_lyrics_array[line_num] = lyrics_array[line_num]
        end
        cleaned_line = nil
      end # END lyrics_array.length.times


      # Convert highlighted_lyrics_array into string with <br> as delimiters
      highlighted_lyrics = ""
      highlighted_lyrics_array.each do |line|
        highlighted_lyrics << "#{line}<br>"
      end

      return bad_lines.sort.to_h, highlighted_lyrics
    end

end
