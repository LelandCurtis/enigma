require './lib/enigma'
require 'date'
require './lib/helper_methods'

include HelperMethods

message_path = ARGV[0]
encrypted_path = ARGV[1]
if ARGV[2] == nil then date = today else date = ARGV[2] end

cyphertext = File.read(message_path)

enigma = Enigma.new()
encryption_hash = enigma.crack_hard(cyphertext)

new_file = File.open(encrypted_path, "w")
new_file.write(encryption_hash[:decryption])
new_file.close

puts "Created '#{encrypted_path}' with the cracked key #{encryption_hash[:key]} and date #{encryption_hash[:date]}"
