require 'simplecov'
SimpleCov.start

require './cypher'

describe Cypher do
  before(:each) do
    @key = '02715'
    @date = '040895'
    @cypher = Cypher.new(@key, @date)
  end
  describe 'initialize' do
    it 'exists' do
      expect(@cypher).to be_a(Cypher)
    end
    it 'has attributes' do
      expect(@cypher.key).to eq(@key)
      expect(@cypher.date).to eq(@date)
      expect(@cypher.shifts).to be_a(Array)
    end
    it 'initializes shifts array' do
      expect(@cypher.shifts).to eq([3,27,73,20])
    end
  end

  describe 'methods' do
    describe ' #calc_keys' do
      it 'returns and Array' do
        expect(@cypher.calc_keys).to be_a(Array)
      end
      it 'returns an array of integers' do
        expect(@cypher.calc_keys.all?{|v|v.class == Integer}).to eq(true)
      end
      it 'returns correct keys' do
        expect(@cypher.calc_keys).to eq([2,27,71,15])
      end
    end

    describe ' #calc_offsets' do
      it 'returns and Array' do
        expect(@cypher.calc_offsets).to be_a(Array)
      end
      it 'returns an array of integers' do
        expect(@cypher.calc_offsets.all?{|v|v.class == Integer}).to eq(true)
      end
      it 'returns correct offsets' do
        expect(@cypher.calc_offsets).to eq([1,0,2,5])
      end
    end

    describe ' #calc_shifts' do
      it 'returns and Array' do
        expect(@cypher.calc_shifts).to be_a(Array)
      end
      it 'returns an array of integers' do
        expect(@cypher.calc_shifts.all?{|v|v.class == Integer}).to eq(true)
      end
      it 'returns correct shifts' do
        expect(@cypher.calc_shifts).to eq([3,27,73,20])
      end
    end
  end
end
