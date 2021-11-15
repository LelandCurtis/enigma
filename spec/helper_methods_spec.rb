require 'simplecov'
SimpleCov.start

require './lib/helper_methods'

describe HelperMethods do
  describe ' #today' do
    it 'returns a string' do
      expect(@enigma.today).to be_a(String)
    end
    it 'returns correct date' do
      expect(@enigma.today).to eq('111121')
    end
  end
end
