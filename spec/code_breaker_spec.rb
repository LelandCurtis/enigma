require 'simplecov'
SimpleCov.start

require './lib/cypher'
require './lib/code_breaker'
require './lib/encoder'

describe CodeBreaker do
  before(:each) do
    @message = 'hello world! end'
    @key = '02715'
    @date = '040895'
    @breaker = CodeBreaker.new()
  end

  describe 'initialize' do
    it 'exists' do
      expect(@breaker).to be_a(CodeBreaker)
    end
    it 'has attributes' do
      expect(@breaker.alphabet).to eq(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "])
      expect(@breaker.shifts).to eq([])
      expect(@breaker.cypher).to be_a(Cypher)
    end
  end

  describe 'methods' do
    before(:each) do
      @crackable_message = 'This is a crackable message end'
      @crackable_message_2 = 'This is a crackable message! end'
      @cypher = Cypher.new(@key, @date)
      @encoder = Encoder.new(@cypher)
      @breaker = CodeBreaker.new()
      @cyphertext = @encoder.encrypt_message(@crackable_message)
      @cyphertext_2 = @encoder.encrypt_message(@crackable_message_2)
    end

    describe ' #find_shifts' do
      it 'returns an array from a message' do
        expect(@breaker.find_shifts(@crackable_message)).to be_a(Array)
      end
      it 'returns an array of 4 values' do
        expect(@breaker.find_shifts(@crackable_message).count).to eq(4)
      end
      it 'returns an array of integers' do
        expect(@breaker.find_shifts(@crackable_message).all?{|v|v.class == Integer}).to eq(true)
      end
      it 'returns the expect shift in proper order' do
        expected = @cypher.shifts
        expect(@breaker.find_shifts(@cyphertext)).to eq(expected)
      end
      it 'returns the expect shift in proper order' do
        expected = @cypher.shifts
        expect(@breaker.find_shifts(@cyphertext_2)).to eq(expected)
      end
      it 'returns shifts that can decrypt entire message' do
        @breaker.find_shifts(@cyphertext)
        expect(@breaker.decrypt_message(@cyphertext)).to eq(@crackable_message)
      end
    end

    describe ' #possible_shifts' do
      before(:each) do
        @shifts = [5 , 25, 26, 10]
        @possible_shifts = [['05', '32', '59', '86'],
                                ['25', '52', '79'],
                                ['26', '53', '80'],
                                ['10', '37', '64', '91']]
      end
      it 'returns an Array' do
        expect(@breaker.possible_shifts(@shifts)).to be_a(Array)
      end
      it 'returns an Array of Arrays' do
        expect(@breaker.possible_shifts(@shifts).all?{|v|v.class == Array}).to eq(true)
      end
      it 'returns 2-digit string values inside arrays' do
        expect(@breaker.possible_shifts(@shifts).flatten.all?{|v|v.class == String && v.chars.count == 2}).to eq(true)
      end
      it 'returns correct values' do
        expect(@breaker.possible_shifts(@shifts)).to eq(@possible_shifts)
      end
    end

    describe ' #valid_shift?' do
      before(:each) do
        @shift_1 = '05'
        @shift_2 = '51'
        @shift_3 = '65'
      end
      it 'returns a boolean' do
        expect(@breaker.valid_shift?(@shift_1, @shift_2)).to be_a(TrueClass || FalseClass)
      end
      it 'returns true if second index of first key matches first index of the secnd key' do
        expect(@breaker.valid_shift?(@shift_1, @shift_2)).to eq(true)
      end
      it 'returns false if second index of first key does not match the first index of the secnd key' do
        expect(@breaker.valid_shift?(@shift_1, @shift_3)).to eq(false)
      end
    end

    describe ' #find_valid_shift' do
      before(:each) do
        @shift_1 = '05'
        @viable_shifts = [['05', '32'], ['25', '52'], ['26', '53'], ['37', '64']]
      end
      it 'returns a String' do
        expect(@breaker.find_valid_shift(@shift_1, @viable_shifts[1])).to be_a(String)
      end
      it 'returns the correct string' do
        expect(@breaker.find_valid_shift(@shift_1, @viable_shifts[1])).to eq('52')
      end

    end

    describe ' #viable_shifts' do
      before(:each) do
        @possible_shifts = [['05', '32', '59', '86'],
                                ['25', '52', '79'],
                                ['26', '53', '80'],
                                ['10', '37', '64', '91']]
        @viable_shifts = [['05', '32'],
                                ['25', '52'],
                                ['26', '53'],
                                ['37', '64']]
      end
      it 'returns an Array' do
        expect(@breaker.viable_shifts(@possible_shifts)).to be_a(Array)
      end
      it 'returns an Array of Arrays' do
        expect(@breaker.viable_shifts(@possible_shifts).all?{|v|v.class == Array}).to eq(true)
      end
      it 'returns correct values' do
        expect(@breaker.viable_shifts(@possible_shifts)).to eq(@viable_shifts)
      end
    end

    describe ' #build_keys' do
      before(:each) do
        @viable_shifts = [['05', '32'], ['25', '52'], ['26', '53'], ['37', '64']]
      end
      it 'returns an array' do
        expect(@breaker.build_keys(@viable_shifts)).to be_a(Array)
      end
      it 'returns an Array of 5 character Strings' do
        expect(@breaker.build_keys(@viable_shifts).all?{|v|v.class == String && v.chars.count == 5}).to eq(true)
      end
      it 'returns the correct array of keys' do
        expected = ['05264', '32537']
      end
    end

    describe ' #crack_keys' do
      it ' returns a string' do
        expect(@breaker.crack_keys(@cyphertext, @date)).to be_a(String)
      end
      it 'returns the correct string' do
        expect(@breaker.crack_keys(@cyphertext, @date)).to eq(@key)
      end
    end

    describe ' #crack_easy' do
      it 'updates the cypher shifts' do
        expect(@breaker.cypher.shifts).to eq(nil)
        @breaker.crack_easy(@cyphertext)
        expect(@breaker.cypher.shifts).to eq([3, 0, 19, 20])
      end
    end

    describe ' #crack_hard' do
      # before(:each) do
      #   allow(@breaker).to receive(:generate_dates).and_return(['211095', @date])
      # end
      it 'returns a hash' do
        expect(@breaker.crack_hard(@cyphertext)).to be_a(Hash)
      end
      it 'returns a hash with a date and a key' do
        expect(@breaker.crack_hard(@cyphertext).keys).to eq([:date, :key])
      end
      it 'returns a hash with date and key string values' do
        expect(@breaker.crack_hard(@cyphertext).values.all?{|v|v.class == String}).to eq(true)
      end
      it 'updates cypher with key and date values' do
        expect(@breaker.cypher.date).to eq(nil)
        expect(@breaker.cypher.key).to eq(nil)
        @breaker.crack_hard(@cyphertext)
        expect(@breaker.cypher.date).to eq('010105')
        expect(@breaker.cypher.key).to eq('02715')
      end

    end

    describe ' #generate_dates' do
      before(:each) do
        @months = %w(01 02 03 04 05 06 07 08 09 10 11 12)
        @days =  ('1'..'31').to_a.map{|num| '%02d' % num}
        @years = ('0'..'99').to_a.map{|num| '%02d' % num}
      end
      it 'returns an array' do
        expect(@breaker.generate_dates).to be_a(Array)
      end
      it 'does not return any invalid month values' do
        expect(@breaker.generate_dates.all?{|date|@months.include?(date.chars[2..3].join(''))}).to eq(true)
      end
      it 'does not return any invalid day values' do
        expect(@breaker.generate_dates.all?{|date|@days.include?(date.chars[0..1].join(''))}).to eq(true)
      end
      # it 'does not return any invalid year values' do
      #   expect(@breaker.generate_dates.all?{|date|@years.include?([date.chars[4..5].join(''))}).to eq(true)
      # end
    end
  end
end
