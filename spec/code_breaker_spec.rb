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

    # describe ' #crack_keys' do
    #   it ' returns keys' do
    #
    #   end
    # end

    describe ''
  end
end
