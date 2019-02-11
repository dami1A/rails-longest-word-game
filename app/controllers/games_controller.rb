require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('a'..'z').to_a.sample.capitalize
    end
  end

  def score
    @grid = params[:letters].split(' ')
    @word = params[:word]
    @start_time = params[:start_time]
    @end_time = Time.now
    @result = {}
    # binding.pry
    @result[:time] = @end_time - @start_time.to_time
    @executive_test = word_testeur(@word, @grid)
    @executive_test["found"] ? @result[:score] = ((1 / @result[:time])*100).round / 100.0 + @word.length.to_f : @result[:score] = 0
    @executive_test["found"] ? @result[:message] = "Congratulations! '#{@word.upcase}' is a valid English word!" : @result[:message] = @executive_test["error"]
  end

  def word_testeur(word, grid)
    first_test = true
    word.upcase.split(//).each do |letter|
      first_test = first_test && grid.include?(letter)
      grid.delete_at(grid.index(letter)) if grid.include?(letter)
    end
    if first_test == true
      final_test = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word}").read)
      final_test["error"] = "Sorry but '#{word.upcase}' does not seem to be a valid English word" if final_test["found"] == false
    else
      final_test = { "found" => false, "word" => word, "error" => "Sorry but '#{word.upcase}' can be built out of the grid" }
    end
    return final_test
  end
end
