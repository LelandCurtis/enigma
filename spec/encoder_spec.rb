require './lib/encoder'
require './lib/cypher'

describe Encoder do
  before(:each) do
    @message = 'hello world!'
    @key = '02715'
    @date = '040895'
    @cypher = Cypher.new(@key, @date)
    @encoder = Encoder.new(@message, @cypher)
  end

  describe 'initialize' do
    it 'exists' do
      expect(@encoder).to be_a(Encoder)
    end
    it 'has attributes' do
      expect(@encoder.message).to eq(@message)
      expect(@encoder.cypher).to be_a(Cypher)
      expect(@encoder.index_message).to be_a(Array)
      expect(@encoder.letter_message).to be_a(Array)
      expect(@encoder.alphabet).to eq(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "])
    end
    it 'initializes letter_message array' do
      expected = ["h", "e", "l", "l", "o", " ", "w", "o", "r", "l", "d"]
      expect(@encoder.letter_message).to eq(expected)
    end
    it 'initializes index_message array' do
      expected = [7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3]
      expect(@encoder.index_message).to eq(expected)
    end
  end

  describe 'methods' do
    describe ' #valid?' do
      it 'returns true if character is in alphabet' do
        expect(@encoder.valid?("a")).to eq(true)
        expect(@encoder.valid?(" ")).to eq(true)
      end
      it 'returns false if character is not in alphabet' do
        expect(@encoder.valid?("!")).to eq(false)
        expect(@encoder.valid?("2")).to eq(false)
        expect(@encoder.valid?("$")).to eq(false)
      end
    end

    describe ' #clean' do
      it 'removes all characters not in alphabet' do
        expect(@encoder.clean('he^ll2o wor_ld!')).to eq('hello world')
      end
      it 'returns lowercase' do
        expect(@encoder.clean('Hello World')).to eq('hello world')
      end
      it 'returns correctly cleaned messages' do
        expect(@encoder.clean('He^ll2o woR_lD!')).to eq('hello world')
      end
    end

    describe ' #create_letter_message' do
      it 'returns an array' do
        expect(@encoder.create_letter_array('hi')).to be_a(Array)
      end
      it 'returns a properly cleaned array' do
        message = 'Hi! 4d'
        expect(@encoder.create_letter_array(message)).to eq(['h', 'i', ' ', 'd'])
      end
    end

    describe ' #create_index_message' do
      it 'returns an array' do
        expect(@encoder.create_index_message('hi')).to be_a(Array)
      end
      it 'returns a properly cleaned array' do
        message = 'Hi! 4d'
        expect(@encoder.create_index_message(message)).to eq([7, 8, 26, 3])
      end
    end

    describe ' #shift' do
      it 'returns an array' do
        expect(@encoder.shift(@encoder.index_message)).to be_a(Array)
      end
      it 'returns an array of integers' do
        expect(@encoder.shift(@encoder.index_message.all?{|v|v.class == Integer}).to eq(true)
      end
      it 'returns correctly shifted array of integers' do
        expected = [10, 4, 3, 4, 17, 26, 14, 14, 20, 11, 22]
        expect(@encoder.shift(@encoder.index_message)).to eq(expected)
      end
    end

    describe ' #finish_message' do
      it 'returns a string' do
        expect(@encoder.finish_message('keder ohulw!')).to be_a(String)
      end
      it 'returns a string with correct uppercase' do
        @encoder_2 = Encoder.new('Hello World')
        expect(@encoder.finish_message('keder ohulw')).to eq('Keder Ohulw')
      end
      it 'returns a string with original punctuation' do
        @encoder_2 = Encoder.new('hello world!')
        expect(@encoder.finish_message('keder ohulw')).to eq('keder ohulw!')
      end
      it 'returns a string with original punctuation and uppercase letters' do
        @encoder_2 = Encoder.new('Hel_lo Wor6ld!')
        expect(@encoder.finish_message('keder ohulw')).to eq('Ked_er Ohu6lw!')
      end
    end

    describe ' #encrypt' do
      it 'returns a string' do
        expect(@encoder.encrypt).to be_a(String)
      end
      it 'returns a properly encrypted string' do
        expect(@encoder.encrypt).to eq('keder ohulw')
      end
    end

    describe ' #decrypt' do
      it 'returns a string' do
        expect(@encoder.encrypt).to be_a(String)
      end
      it 'returns a properly decrypted string' do
        expect(@encoder.decrypt).to eq('hello world')
      end
    end
  end
end



#       it 'returns an array of integers' do
#         expect(@encoder.calc_keys.all?{|v|v.class == Integer}).to eq(true)
#       end
#       it 'returns correct keys' do
#         expect(@encoder.calc_keys).to eq([2,27,71,15])
#       end
# xit 'initializes letter_message array' do
#   expected = ["k", "e", "d", "e", "r", " ", "o", "h", "u", "l", "w"]
#   expect(@encoder.letter_message).to eq(expected)
# end
#     end
#   end
# end
