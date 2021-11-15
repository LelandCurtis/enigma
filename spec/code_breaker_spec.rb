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
      @cypher = Cypher.new(@key, @date)
      @encoder = Encoder.new(@cypher)
      @breaker = CodeBreaker.new()
      @cyphertext = @encoder.encrypt_message(@crackable_message)
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
      it 'returns shifts that can decrypt entire message' do
        @breaker.find_shifts(@cyphertext)
        expect(@breaker.decrypt_message(@cyphertext)).to eq(@crackable_message)
      end
    end

    describe ' #possible_key_shifts' do
      before(:each) do
        @key_shifts = [5 , 52, 26, 64]
        @possible_key_shifts = [['05', '32', '59', '86'],
                                ['25', '52', '79'],
                                ['26', '53', '80'],
                                ['10', '37', '64', '91']]
      end
      it 'returns an Array' do
        expect(@breaker.possible_key_shifts(@key_shifts)).to be_a(Array)
      end
      it 'returns an Array of Arrays' do
        expect(@breaker.possible_key_shifts(@key_shifts).all?{|v|v.class == Array}).to eq(true)
      end
      it 'returns 2-digit string values inside arrays' do
        expect(@breaker.possible_key_shifts(@key_shifts).flatten.all?{|v|v.class == String && v.chars.count == 2}).to eq(true)
      end
      it 'returns correct values' do
        expect(@breaker.possible_key_shifts(@key_shifts)).to eq(@possible_key_shifts)
      end
    end

    describe ' #valid_key_shift?' do
      before(:each) do
        @key_1 = '05'
        @key_2 = '51'
        @key_3 = '65'
      end
      it 'returns a boolean' do
        expect(@breaker.valid_key_shift?(@key_1, @key_2)).to be_a(TrueClass || FalseClass)
      end
      it 'returns true if second index of first key matches first index of the secnd key' do
        expect(@breaker.valid_key_shift?(@key_1, @key_2)).to eq(true)
      end
      it 'returns false if second index of first key does not match the first index of the secnd key' do
        expect(@breaker.valid_key_shift?(@key_1, @key_3)).to eq(false)
      end
    end

    describe ' #clean_keys' do
      before(:each) do
        @possible_key_shifts = [['05', '32', '59', '86'],
                                ['25', '52', '79'],
                                ['26', '53', '80'],
                                ['10', '37', '64', '91']]
      end
      it 'returns an Array' do
        expect(@breaker.clean_keys(@possible_key_shifts)).to be_a(Array)
      end
      it 'returns an Array of Arrays' do
        expect(@breaker.clean_keys(@possible_key_shifts).all?{|v|v.class == Array}).to eq(true)
      end
      it 'returns correct values' do
        expect(@breaker.clean_keys(@possible_key_shifts)).to eq(@possible_key_shifts)
      end
    end

    describe ' #crack_keys' do
      it ' returns a string' do
        expect(@breaker.crack_keys(@message, @date)).to be_a(String)
      end
      it 'returns the correct string' do
        expect(@breaker.crack_keys(@message, @date)).to eq(@key)
      end
    end
  end
end
