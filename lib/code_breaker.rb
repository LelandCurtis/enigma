require './lib/cypher'
require './lib/code_breaker'
require './lib/encoder'

class CodeBreaker < Encoder
  attr_accessor :shifts

  def initialize
    @shifts = []
    @alphabet = @@alphabet
  end

  def find_shifts(message)
    correct = [26, 4, 13, 3]
    last_4_index = create_index_message(message[-4..])
    shifts = [last_4_index, correct].transpose.map{|pair| (pair[0]-pair[1])%27}
    shifts.rotate(4 - message.chars.count % 4)
  end

end
