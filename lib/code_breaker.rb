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
    @cypher.shifts = shifts.rotate(4 - clean(message).chars.count % 4)
  end

  def possible_shifts(shifts)
    possible_shifts = shifts.map do |shift|
      temp = []
      until shift.to_s.chars.count > 2
        temp << '%02d' % shift
        shift += 27
      end
      temp
    end
  end

  def valid_shift?(shift_1, shift_2)
    if shift_1.chars[1] == shift_2.chars[0]
      return true
    else
      return false
    end
  end

  def find_valid_shift(base, array)
    array.select{|shift|valid_shift?(base, shift)}[0]
  end

  def viable_shifts(shifts)
    i = 0
    pass_1= []
    3.times do
      valid_shifts = shifts[i].select do |shift_1|
        shifts[i+1].map{|shift_2| valid_shift?(shift_1, shift_2)}.include?(true)
      end
      i += 1
      pass_1 << valid_shifts
    end
    i = 0
    pass_1 << shifts[3]
    pass_2 = []
    3.times do
      valid_shifts = pass_1.reverse[i].select do |shift_1|
        pass_1.reverse[i+1].map{|shift_2| valid_shift?(shift_2, shift_1)}.include?(true)
      end
      i += 1
      pass_2 << valid_shifts
    end
    viable_shifts = (pass_2 << pass_1[0]).reverse
  end

  def build_keys(shifts)
    shifts[0].map do |shift_start|
      key = []
      key << shift_start
      last_shift = shift_start
      last_chars = shifts[1..-1].map do |shifts|
        last_shift = find_valid_shift(last_shift, shifts)
        last_shift.chars[-1]
      end
      key << last_chars
      key.join('')
    end
  end

  def crack_keys(message, date = today)
    shifts = find_shifts(message)
    @cypher.date = date
    date_offset = @cypher.calc_offsets
    key_shifts = [shifts, date_offset].transpose.map{|pair| (pair[0]-pair[1])%27}
    possible_shifts = possible_shifts(key_shifts)
    viable_shifts = viable_shifts(possible_shifts)
    keys = build_keys(viable_shifts)
    @cypher.key = keys[0]
    @cypher.date = date
    keys[0]
  end

end
