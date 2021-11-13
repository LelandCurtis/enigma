require './lib/cypher'

class Encoder
  attr_accessor :message, :cypher, :letter_message, :index_message, :alphabet
  @@alphabet = ('a'..'z').to_a << ' '
  
  def initialize(cypher)
    @cypher = cypher
    @alphabet = ('a'..'z').to_a << ' '
  end

  def valid?(char)
    alphabet.include?(char)
  end

  def upcase?(char)
    char == char.upcase
  end

  def clean(message)
    lowercase = message.chars.map{|char|char.downcase}
    cleaned_message = lowercase.select{|char|valid?(char)}.join('')
  end

  def create_letter_message(message)
    clean(message).chars
  end

  def create_index_message(message)
    create_letter_message(message).map{|letter| alphabet.index(letter)}
  end

  def shift(index_message)
    shifted = []
    index_message.each_with_index do|letter_index, index|
      shifted << (letter_index + @cypher.shifts[index % 4])%27
    end
    shifted
  end

  def unshift(index_message)
    unshifted = []
    index_message.each_with_index do|letter_index, index|
      unshifted << (letter_index - @cypher.shifts[index % 4])%27
    end
    unshifted
  end

  def encrypt(message)
    index_message = create_index_message(message)
    shift(index_message).map{|index| @alphabet[index]}.join('')
  end

  def decrypt(message)
    index_message = create_index_message(message)
    unshift(index_message).map{|index| @alphabet[index]}.join('')
  end

  def finish_message(new, original)
    new_chars = new.chars
    original.chars.each_with_object(finished_message = []) do |char|
      if valid?(char.downcase)
        finished_message << (upcase?(char) ? new_chars.shift.upcase : new_chars.shift)
      else
        finished_message << char
      end
    end.join('')
  end

  def encrypt_message(message)
    finish_message(encrypt(message), message)
  end

  def decrypt_message(message)
    finish_message(decrypt(message), message)
  end
end
