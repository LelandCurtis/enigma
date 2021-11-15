require 'simplecov'
SimpleCov.start

require './lib/encoder'
require './lib/cypher'

describe Encoder do
  before(:each) do
    @message = 'hello world!'
    @key = '02715'
    @date = '040895'
    @cypher = Cypher.new(@key, @date)
    @encoder = Encoder.new(@cypher)
    @big_message = "Hello world!
This is an example long message with exclamation and multiple lines!
I hope this is tough enough

TO
trip_up my encoder and decrypter. end"
  end

  describe 'initialize' do
    it 'exists' do
      expect(@encoder).to be_a(Encoder)
    end
    it 'has attributes' do
      expect(@encoder.cypher).to be_a(Cypher)
      expect(@encoder.alphabet).to eq(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " "])
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

    describe ' #upcase?' do
      it 'returns true if character is not lowercase' do
        expect(@encoder.upcase?('A')).to eq(true)
        expect(@encoder.upcase?('!')).to eq(true)
      end
      it 'returns false if character is lowercase' do
        expect(@encoder.upcase?('a')).to eq(false)
        expect(@encoder.upcase?(' ')).to eq(false)
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
      it 'returns correctly cleaned large multi-line messages' do
        expected = "hello worldthis is an example long message with exclamation and multiple linesi hope this is tough enoughtotripup my encoder and decrypter end"
        expect(@encoder.clean(@big_message)).to eq(expected)
      end
    end

    describe ' #create_letter_message' do
      it 'returns an array' do
        expect(@encoder.create_letter_message('hi')).to be_a(Array)
      end
      it 'returns a properly cleaned array' do
        message = 'Hi! 4d'
        expect(@encoder.create_letter_message(message)).to eq(['h', 'i', ' ', 'd'])
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
        expect(@encoder.shift([0,0,0,0,0,0,0,0])).to be_a(Array)
      end
      it 'returns an array of integers' do
        expect(@encoder.shift([0,0,0,0,0,0,0,0]).all?{|v|v.class == Integer}).to eq(true)
      end
      it 'returns correctly shifted array of integers' do
        expected = [3, 0, 19, 20, 3, 0, 19, 20]
        expect(@encoder.shift([0,0,0,0,0,0,0,0])).to eq(expected)
      end
    end

    describe ' #unshift' do
      it 'returns an array' do
        expect(@encoder.unshift([0,0,0,0,0,0,0,0])).to be_a(Array)
      end
      it 'returns an array of integers' do
        expect(@encoder.unshift([0,0,0,0,0,0,0,0]).all?{|v|v.class == Integer}).to eq(true)
      end
      it 'returns correctly shifted array of integers' do
        expected = [24, 0, 8, 7, 24, 0, 8, 7]
        expect(@encoder.unshift([0,0,0,0,0,0,0,0])).to eq(expected)
      end
      it 'correctly shifts all values' do
        all_ints = (0..26).to_a
        expected = [24, 1, 10, 10, 1, 5, 14, 14, 5, 9, 18, 18, 9, 13, 22, 22, 13, 17, 26, 26, 17, 21, 3, 3, 21, 25, 7]
        expect(@encoder.unshift(all_ints)).to eq(expected)
      end
    end

    describe ' #finish_message' do
      it 'returns a string' do
        expect(@encoder.finish_message('keder ohulw!', @message)).to be_a(String)
      end
      it 'returns a string with correct uppercase' do
        expect(@encoder.finish_message('keder ohulw', "Hello World")).to eq('Keder Ohulw')
      end
      it 'returns a string with original punctuation' do
        expect(@encoder.finish_message('keder ohulw', 'hello world!')).to eq('keder ohulw!')
      end
      it 'returns a string with original punctuation and uppercase letters' do
        expect(@encoder.finish_message('keder ohulw', 'Hel_lo Wor6ld!')).to eq('Ked_er Ohu6lw!')
      end
    end

    describe ' #encrypt' do
      it 'returns a string' do
        expect(@encoder.encrypt('hello world!')).to be_a(String)
      end
      it 'returns a properly encrypted string' do
        expect(@encoder.encrypt('hello world')).to eq('keder ohulw')
      end
    end

    describe ' #decrypt' do
      it 'returns a string' do
        expect(@encoder.decrypt('keder ohulw')).to be_a(String)
      end
      it 'returns a properly decrypted string' do
        expect(@encoder.decrypt('keder ohulw')).to eq('hello world')
      end
    end

    describe ' #encrypt_message' do
      it 'returns a string' do
        expect(@encoder.encrypt_message('Hel_lo Wor6ld!')).to be_a(String)
      end
      it 'returns a properly encrypted string' do
        expect(@encoder.encrypt_message('hello world!')).to eq('keder ohulw!')
        expect(@encoder.encrypt_message('Hel_lo Wor6ld!')).to eq('Ked_er Ohu6lw!')
      end
    end

    describe ' #decrypt_message' do
      it 'returns a string' do
        expect(@encoder.decrypt('Ked_er Ohu6lw!')).to be_a(String)
      end
      it 'returns a properly encrypted string' do
        expect(@encoder.decrypt_message('keder ohulw!')).to eq('hello world!')
        expect(@encoder.decrypt_message('Ked_er Ohu6lw!')).to eq('Hel_lo Wor6ld!')
      end
    end

    describe ' encrypt and decrypt integration test' do
      it 'can encrypt and decrypt large complicated messages' do
        big_cyphertext = @encoder.encrypt_message(@big_message)
        expect(@encoder.decrypt_message(big_cyphertext)).to eq(@big_message)
      end
    end
  end
end
