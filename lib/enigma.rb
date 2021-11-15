require 'date'
require './lib/cypher'
require './lib/encoder'
require './lib/helper_methods'

class Enigma
  include HelperMethods

  def initialize
  end

  def random_key
    '%05d' % rand(0..99999)
  end

  def encrypt(message, key = random_key, date = today)
    cypher = Cypher.new(key, date)
    encoder = Encoder.new(cypher)
    cyphertext = encoder.encrypt_message(message)
    return {:encryption => cyphertext, :key => key, :date => date}
  end

  def decrypt(message, key = random_key, date = today)
    cypher = Cypher.new(key, date)
    encoder = Encoder.new(cypher)
    message = encoder.decrypt_message(message)
    return {:decryption => message, :key => key, :date => date}
  end
end
