require 'date'
require './lib/cypher'
require './lib/encoder'
require './lib/helper_methods'
require './lib/code_breaker'

class Enigma
  include HelperMethods

  def initialize
  end

  def encrypt(message, key = random_key, date = today)
    cypher = Cypher.new(key, date)
    encoder = Encoder.new(cypher)
    cyphertext = encoder.encrypt_message(message)
    return {:encryption => cyphertext, :key => key, :date => date}
  end

  def decrypt(cyphertext, key = random_key, date = today)
    cypher = Cypher.new(key, date)
    encoder = Encoder.new(cypher)
    message = encoder.decrypt_message(cyphertext)
    return {:decryption => message, :key => key, :date => date}
  end

  def crack(cyphertext, date = today)
    breaker = CodeBreaker.new
    key = breaker.crack_keys(cyphertext, date)
    message = breaker.decrypt_message(cyphertext)
    return {:decryption => message, :key => key, :date => date}
  end

  def crack_easy(cyphertext)
    breaker = CodeBreaker.new
    breaker.find_shifts(breaker.clean(cyphertext))
    message = breaker.decrypt_message(cyphertext)
    return {:decryption => message, :key => 'Key not needed for decryption', :date => 'Date not needed for decryption'}
  end
end
