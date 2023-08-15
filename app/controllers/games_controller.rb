require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @start = Time.now.to_f
  end

  def score
    # Versuch
    @start_time = params[:start].to_f
    @end_time = Time.now.to_f
    @result = params[:result]
    @letters = params[:letters].split(" ")
    @final = run_game(@result, @letters, @start_time, @end_time)
  end

  private

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    duration = end_time - start_time
    if word_grid_check(attempt, grid)
      word = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
      word["found"] ? score = attempt.size / (end_time - start_time) : score = 0
      word["found"] ? message = "Well done" : message = "Sorry, but #{attempt} is not an english word"
      return { :score => score, :message => message, :time => duration }
    else
      return { :score => 0, :message => "Sorry, but #{attempt} is not in the grid", :time => duration }
    end
  end

  def word_grid_check(attempt, grid)
    attempt = attempt.upcase.chars
    attempt.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
    end
    return true
  end
end
