require './lib/enigma'
require 'date'
require './lib/helper_methods'

include HelperMethods

message_path = ARGV[0]
encrypted_path = ARGV[1]

cyphertext = File.read(message_path)

enigma = Enigma.new()
encryption_hash = enigma.crack_easy(cyphertext)

new_file = File.open(encrypted_path, "w")
new_file.write(encryption_hash[:decryption])
new_file.close

puts "Created '#{encrypted_path}' without a key or date."
