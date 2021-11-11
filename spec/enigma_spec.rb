require 'date'
require './lib/egnima'
require './lib/cypher'
require './lib/encoder'

describe Enigma do
  before(:each) do
    @enigma = Enigma.new()
  end
  describe 'initialize' do
    it 'exists' do
      expect(@enigma).to be_a(Enigma)
    end
    it 'has attributes' do
    end
  end

  describe 'methods' do
    before(:each) do
      @message = 'hello world'
      @key = '02715'
      @date = '040895'
      @cyphertext = double('cyphertext')
      allow(@cyphertext).to receive(:decrypt).and_return(@message)
    end

    describe ' #today' do
      it 'returns a string' do
        expect(@enigma.today).to be_a(String)
      end
      it 'returns correct date' do
        expect(@enigma.today).to eq('111121')
      end
    end

    describe ' #encrypt' do
      it 'returns a hash' do
        expect(@enigma.encrypt(@message, @key, @date)).to be_a(Hash)
      end
      it 'returns a hash with correct keys' do
        expected = [:encryption, :key, :date]
        expect(@enigma.encrypt(@message, @key, @date).keys).to eq(expected)
      end
      it 'returns correct key' do
        expect(@enigma.encrypt(@message, @key, @date)[:key]).to eq(@key)
      end
      it 'returns correct date' do
        expect(@enigma.encrypt(@message, @key, @date)[:date]).to eq(@date)
      end
      it 'returns string as encryption' do
        expect(@enigma.encrypt(@message, @key, @date)[:encryption]).to be_a(String)
      end
      it 'returns correct encryption' do
        message_mock = double('message_mock')
        allow(message_mock).to receive(:encrypt).and_return(@cyphertext)
        expected = @cyphertext
        expect(@enigma.encrypt(message_mock, @key, @date)[:encryption]).to eq(expected)
      end
    end

    describe ' #decrypt' do
      it 'returns a hash' do
        expect(@enigma.decrypt(@cyphertext, @key, @date)).to be_a(Hash)
      end
      it 'returns a hash with correct keys' do
        expected = [:decryption, :key, :date]
        expect(@enigma.decrypt(@cyphertext, @key, @date).keys).to eq(expected)
      end
      it 'returns correct key' do
        expect(@enigma.decrypt(@cyphertext, @key, @date)[:key]).to eq(@key)
      end
      it 'returns correct date' do
        expect(@enigma.decrypt(@cyphertext, @key, @date)[:date]).to eq(@date)
      end
      it 'returns string as decryption' do
        expect(@enigma.decrypt(@cyphertext, @key, @date)[:decryption]).to be_a(String)
      end
      it 'returns correct decryption' do
        expect(@enigma.decrypt(@cyphertext, @key, @date)[:decryption]).to eq(@message)
      end
    end
  end
end
