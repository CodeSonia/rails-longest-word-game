# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alpha_range = ('A'..'Z')
    alphabet_arr = alpha_range.to_a

    @letters = alphabet_arr.sample(10)
  end

  def score
    word = params[:word]
    letters = params[:grid].downcase.split('')

    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)

    letters_array = []
    word.downcase.chars.each do |letter|
      letters_array << letter if letters.include?(letter)
    end

    flash[:word_attempt] = word

    if json['found']
      # raise
      if letters_array.length == word.length
        score = word.length
        flash[:notice] = "Yay! Well done, you're score is #{score}"
      else
        flash[:alert] = "Oh no, #{word} uses letters not in the letters provided."
      end
    else
      flash[:alert] = "Sorry, #{word} is not an English word"
    end
  end
end

