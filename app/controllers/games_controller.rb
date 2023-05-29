# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    word = params[:word].downcase
    letters = params[:grid].downcase

    letters_array = []
    word.chars.each do |letter|
      letters_array << letter if letters.include?(letter)
    end

    if letters_array.join != word
      @message = "The #{word} can't be built out of the original grid"
    elsif letters_array.join == word && fetch_api(word) == false
      @message = "The #{word} is not a valid English word"
    elsif letters_array.join == word && fetch_api(word) == true
      @message = "Congratulations! #{word} is a valid English word"
    end
  end

  def fetch_api(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json_serialized = JSON.parse(response.read)

    json_serialized['found'] == true
  end
end
