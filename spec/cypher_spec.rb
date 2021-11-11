require './cpyher'

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
      allow(@enigma).to receive(:calc_shifts).and_return([1,2,3,4])
      expect(@cypher.shifts).to eq(@enigma.calc_shifts)
    end
  end

  describe 'methods' do
    before(:each) do

    end
    describe ' #keys_from_key' do
      it 'returns and Array' do
        expect(@cypher.keys_from_key).to be_a(Array)
      end
      it 'returns an array of integers' do
        expect(@cypher.keys_from_key.all?{|v|v.class = Integer}).to eq(true)
      end
      it 'returns correct keys' do
        expect(@cypher.keys_from_key).to eq([2,27,71,15])
      end
    end

    describe ' #calc_offsets' do
      it 'returns and Array' do
        expect(@cypher.calc_offsets).to be_a(Array)
      end
      it 'returns an array of integers' do
        expect(@cypher.calc_offsets.all?{|v|v.class = Integer}).to eq(true)
      end
      it 'returns correct offsets' do
        expect(@cypher.calc_offsets).to eq([6,6,4,1])
      end
    end

    describe ' #calc_shifts' do
      it 'returns and Array' do
        expect(@cypher.calc_shifts).to be_a(Array)
      end
      it 'returns an array of integers' do
        expect(@cypher.calc_shifts.all?{|v|v.class = Integer}).to eq(true)
      end
      it 'returns correct shifts' do
        expect(@cypher.calc_shifts).to eq([8,33,75,16])
      end
    end
  end
