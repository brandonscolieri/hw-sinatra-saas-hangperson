class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  attr_accessor :word, :guesses, :wrong_guesses, :guess, :allGuesses
  
  def initialize(word)
    @word = word.downcase
    @guess = ""
    @guesses = ""
    @wrong_guesses = ""
    @allGuesses = Set.new
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end


  def hasGuessed?(defaultWord = @guess)
    if isValidGuess?(defaultWord)
      recentGuessSet = defaultWord.split("").to_set
      collisions = @allGuesses & recentGuessSet
      if collisions.empty?
        return false
      else
        return true
      end
    else
      return "Invalid input."
    end
  end


  def guess userGuess
    @guess = userGuess.to_s.downcase
    self.updateGameState
  end


  def updateGameState
    if isValidGuess?(@guess)
      if hasGuessed?
        return false
      else
        @allGuesses.add(@guess)
        if isCorrectGuess?
          puts "Correct!"
          @guesses += @guess
        else
          puts "Incorrect Guess!"
          @wrong_guesses += @guess
        end
      end
    end
  end


  def isCorrectGuess?
    if isValidGuess?(@guess)
      recentGuessSet = @guess.split("").to_set
      secretWord = @word.split("").to_set
      collisions = secretWord & recentGuessSet
      if collisions.empty?
        return false
      else
        return true
      end
    end
  end


  def isValidGuess? guess
    if isValidGuessHelper? guess
      return true
    else
      raise ArgumentError.new("Your guess, #{@guess}, is not valid. Please enter a letter of the alphabet.")
    end
  end


  def isValidGuessHelper? guess
    alphabet = ("a".."z").to_a
    guess = @guess
    alphabet.each do |char|
      if guess[0] == char
        return true
      end
    end
    return false
  end


  def word_with_guesses
    if @guesses.empty? == false
      @word.gsub(/[^#{@guesses}]/, '-')
    else
      @word.gsub(/./, '-')
    end
  end


  def check_win_or_lose
    secretWord = @word.split("").to_set
    attempts = @guesses.split("").to_set
    if @wrong_guesses.length >= 7
      return :lose
    elsif (attempts == secretWord) & (@wrong_guesses.length < 7)
      return :win
    else
      return :play
    end
  end


end
