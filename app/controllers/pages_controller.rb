class PagesController < ApplicationController
  def home
    
  end

  def analysis
    @song = params[:song]
    @artist = params[:artist]

    if !@song.nil? && !@artist.nil?
      fetcher = Lyricfy::Fetcher.new
      song = fetcher.search @artist, @song
      @lyrics = song.body.gsub("\\n", '</br>') # lyrics separated by '\n'
      @sfw = true
    else
      @error_notice = "Oops...something went wrong!"
    end
  end

end
