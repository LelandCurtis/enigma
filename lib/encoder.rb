require './lib/cypher'

class Encoder
  attr_accessor :message, :cypher, :letter_message, :index_message, :alphabet

  def initialize(message, cypher)
    @message = message
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

  def encrypt(message = @message)
    index_message = create_index_message(message)
    shift(index_message).map{|index| @alphabet[index]}.join('')
  end

  def decrypt(message = @message)
    index_message = create_index_message(message)
    unshift(index_message).map{|index| @alphabet[index]}.join('')
  end

  def finish_message(new, original)
    new_array = new.chars
    finished_message = []
    original.each_with_object(i=0) do |char|
      if valid?(char)
        finished_message << new[i]
      else
        finished_message << original[i]
      end
      i += 1
    end
  end
end
