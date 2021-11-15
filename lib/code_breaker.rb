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
        temp << '%02d' % key_shift
        key_shift += 27
      end
      temp
    end
  end

  def valid_key_shift?(key_1, key_2)
    if key_1.chars[1] == key_2.chars[0]
      return true
    else
      return false
    end
  end

  def viable_key_shifts(key_shifts)
    i = 0
    pass_1= []
    3.times do
      valid_key_shifts = key_shifts[i].select do |key_shift_1|
        key_shifts[i+1].map{|key_shift_2| valid_key_shift?(key_shift_1, key_shift_2)}.include?(true)
      end
      i += 1
      pass_1 << valid_key_shifts
    end
    i = 0
    pass_1 << key_shifts[3]
    pass_2 = []
    3.times do
      valid_key_shifts = pass_1.reverse[i].select do |key_shift_1|
        pass_1.reverse[i+1].map{|key_shift_2| valid_key_shift?(key_shift_2, key_shift_1)}.include?(true)
      end
      i += 1
      pass_2 << valid_key_shifts
    end
    viable_key_shifts = (pass_2 << pass_1[0]).reverse
  end

  def crack_keys(message, date = today)
    shifts = find_shifts(message)
    date_offset = @cypher.calc_offsets(date)
    key_shifts = [shifts, date_offset].transpose.map{|pair| (pair[0]-pair[1])%27}
    possible_key_shifts = possible_key_shifts(key_shifts)
  end

end
