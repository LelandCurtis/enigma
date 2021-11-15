require 'simplecov'
SimpleCov.start

require './lib/helper_methods'
include HelperMethods

describe HelperMethods do
  describe ' #today' do
    it 'returns a string' do
      expect(today).to be_a(String)
    end
    it 'returns a 6 digit date' do
      expect(today.chars.count).to eq(6)
    end
  end

  describe 'random_key' do
    it 'generates a string' do
      expect(random_key).to be_a(String)
    end
    it 'generates a 5 character string' do
      expect(random_key.chars.count).to eq(5)
    end
  end
end
