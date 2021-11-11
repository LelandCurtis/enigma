require 'date'
require './lib/cypher'
require './lib/encoder'

class Enigma

  def initialize
  end

  def today
    Date.today.strftime('%d%m%y')
  end

  def encrypt(message, key, date = today)
    #cypher = Cypher.new(key, date)
    #encoder = Encoder.new()
    cyphertext = encoder.encrypt(message, cypher.shift)
    return {:encryption => cyphertext, :key => key, :date => date}
  end

  def decrypt(message, key, date = today)
    #cypher = Cypher.new(key, date)
    #encoder = Encoder.new()
    message = encoder.encrypt(message, cypher.shift)
    return {:decryption => message, :key => key, :date => date}
  end
end
