require './lib/cypher'
require './lib/code_breaker'
require './lib/encoder'
require './lib/helper_methods'

class CodeBreaker < Encoder
  include HelperMethods

  attr_accessor :shifts

  def initialize
    @shifts = []
    @alphabet = @@alphabet
    @cypher = Cypher.new
  end

  def find_shifts(message)
    correct = [26, 4, 13, 3]
    last_4_index = create_index_message(message[-4..])
    shifts = [last_4_index, correct].transpose.map{|pair| (pair[0]-pair[1])%27}
    @cypher.shifts = shifts.rotate(4 - message.chars.count % 4)
  end

  def possible_key_shifts(key_shifts)
    possible_key_shifts = key_shifts.map do |key_shift|
      temp = []
      until key_shift.to_s.chars.count > 2
        temp << key_shift
        key_shift += 27
      end
      temp
    end
    possible_key_shifts
  end

  def crack_keys(message, date = today)
    shifts = find_shifts(message)
    date_offset = @cypher.calc_offsets(date)
    key_shifts = [shifts, date_offset].transpose.map{|pair| (pair[0]-pair[1])%27}

  end

end
