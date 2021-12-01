=begin
Write your code for the 'Bowling' exercise in this file. Make the tests in
`bowling_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/bowling` directory.
=end

class Game 
  class BowlingError < StandardError; end 

  def initialize 
    @unprocessed_rolls = []
    @frames = []
  end

  def roll(pins)
    raise BowlingError if pins < 0 || pins > 10
    raise BowlingError if @frames.length >= 10 

    @unprocessed_rolls << pins 

    if frame_ready_to_be_processed?
      frame = Frame.new(@unprocessed_rolls)
      @frames << frame 
      @unprocessed_rolls = frame.process 
    end
  end

  def score 
    raise BowlingError if @frames.length < 10 

    @frames.collect(&:score).sum 
  end

  def frame_ready_to_be_processed?
    first = @unprocessed_rolls[0]
    second = @unprocessed_rolls[1]
    third = @unprocessed_rolls[2]

    return false if !second 

    if first + second < 10 
      true 
    elsif first == 10 
      second && third 
    elsif first + second == 10
      third 
    else 
      raise BowlingError
    end
  end
end

class Frame  
  attr_reader :score 

  def initialize(rolls)
    @rolls = rolls 
  end

  def process  
    first = @rolls[0]
    second = @rolls[1]
    third = @rolls[2]

    if first == 10 
      if second + third > 10 
        raise Game::BowlingError unless second == 10 
      end
      @score = 10 + second + third 
      @rolls.drop(1)
    elsif first + second == 10 
      @score = 10 + third 
      @rolls.drop(2)
    elsif first + second > 10
      raise Game::BowlingError 
    else
      @score = first + second 
      @rolls.drop(2)
    end
  end
end