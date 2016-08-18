class PagesController < ApplicationController
  def home

  end

  def analysis
    @song = params[:song]
    @artist = params[:artist]

    if !@song.nil? && !@artist.nil?
      fetcher = Lyricfy::Fetcher.new
      song = fetcher.search @artist, @song
      @lyrics = song.body.gsub("\\n", '<br>') # lyrics separated by '\n'
      @isolated_bad_lines = isolated_bad_lines(@lyrics)
      @sfw = @isolated_bad_lines.empty?

      @uniq_isolated_bad_lines = Hash.new
      @isolated_bad_lines.each do |bad_word, bad_lines|
        @uniq_isolated_bad_lines[bad_word] = Array.new
        bad_lines.uniq.each do |uniq_line|
          @uniq_isolated_bad_lines[bad_word] << uniq_line
        end
      end
      puts @uniq_isolated_bad_lines
    else
      @error_notice = "Oops...something went wrong!"
    end
  end

  private
    def isolated_bad_lines(lyrics)
      bad_words_array = ENV["BAD_WORDS"].downcase().split(" ")
      lyrics_array = lyrics.split("<br>")
      bad_lines = Hash.new
      puts "Bad words: #{bad_words_array}"

      bad_words_array.each do |bad_word|
        lyrics_array.each do |line|
          if (line.include? bad_word)
            if bad_lines[bad_word]
              bad_lines[bad_word] << line
            else
              bad_lines[bad_word] = Array.new << line
            end
          end
        end
      end

      return bad_lines
    end

end
