=begin
Write your code for the 'Bowling' exercise in this file. Make the tests in
`bowling_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/bowling` directory.
=end

class Game 
  class BowlingError < StandardError; end 

  def initialize 
    @rolls = []
    @frames = []
  end

  def roll(pins)
    raise BowlingError if pins < 0 || pins > 10
    @rolls << pins 
  end

  def score 
    until @frames.length == 10 do 
      frame = Frame.new(@rolls)
      @frames << frame 
      @rolls = frame.process 
    end

    @frames.collect(&:score).sum 
  end
end

class Frame  
  attr_reader :score 

  def initialize(rolls)
    @rolls = rolls 
  end

  def process  
    if @rolls.first == 10 
      raise Game::BowlingError if !(@rolls[1] && @rolls[2])
      @score = 10 + @rolls[1] + @rolls[2] 
      @rolls.drop(1)
    elsif @rolls.first + @rolls[1] == 10 
      @score = 10 + @rolls[2] 
      @rolls.drop(2)
    elsif @rolls.first + @rolls[1] > 10
      raise Game::BowlingError 
    else
      @score = @rolls.first + @rolls[1] 
      @rolls.drop(2)
    end
  end
end