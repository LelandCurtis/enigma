require 'simplecov'
SimpleCov.start

require './lib/helper_methods'
include HelperMethods

describe HelperMethods do
  describe ' #today' do
    it 'returns a string' do
      expect(today).to be_a(String)
    end
    it 'returns correct date' do
      expect(today).to eq('111121')
    end
  end
end
