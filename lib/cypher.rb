class Cypher
attr_reader :key, :date, :shifts

  def initialize(key, date)
    @key = key
    @date = date
    @shifts = calc_shifts
  end

  def calc_keys
    keys = []
    @key.chars.each_cons(2){|chars| keys << chars.join().to_i}
    keys
  end

  def calc_offsets
    (@date.to_i ** 2).to_s.chars[-4..].map{|digit|digit.to_i}
  end

  def calc_shifts
    keys = calc_keys
    offsets = calc_offsets
    [keys, offsets].transpose.map{|pairs| pairs.sum}
  end
end
