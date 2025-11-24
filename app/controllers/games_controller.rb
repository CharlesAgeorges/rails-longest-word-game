class GamesController < ApplicationController
  require "json"
  require "open-uri"
  def home
  end
  def new
     @letters = ("A".."Z").to_a.sample(10)
     session[:total_score] ||= 0
  end

  def score
    @letters = params[:letters]
    @word = params[:word].upcase

    if !included?(@word, @letters)
      @message = "Sorry #{@word} can't be built with the #{@letters} given to you"
      @score = 0
    elsif !english_word?(@word)
      @message = "Sorry #{@word} is not an english word"
      @score = 0
    else
      @score = @word.length
      @message = "Grat's #{@word} is a valid word. It contains #{@score} letters"

    end

    session[:total_score] ||= 0
    session[:total_score] += @score
    @total_score = session[:total_score]

  end

  def included?(word, letters)
    word.chars.all? { |letter| letters.include?(letter) }
  end

  def english_word?(word)
    url  = "https://dictionary.lewagon.com/#{word.downcase}"
    json = URI.open(url).read
    result = JSON.parse(json)
    result["found"]
  end
end
