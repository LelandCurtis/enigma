require 'date'
require './lib/cypher'
require './lib/encoder'

class Enigma

  def initialize
  end

  def today
    Date.today.strftime('%d%m%y')
  end

  def random_key
    '%06d' % rand(0..999999)
  end

  def encrypt(message, key, date = today)
    cypher = Cypher.new(key, date)
    encoder = Encoder.new(cypher)
    cyphertext = encoder.encrypt_message(message)
    return {:encryption => cyphertext, :key => key, :date => date}
  end

  def decrypt(message, key, date = today)
    cypher = Cypher.new(key, date)
    encoder = Encoder.new(cypher)
    message = encoder.decrypt_message(message)
    return {:decryption => message, :key => key, :date => date}
  end
end
