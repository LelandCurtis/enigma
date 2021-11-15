require './lib/enigma'
require 'date'
require './lib/helper_methods'

include HelperMethods

encrypted_path = ARGV[0]
decrypted_path = ARGV[1]
if ARGV[2] == nil then key = random_key else key = ARGV[2] end
if ARGV[3] == nil then date = today else date = ARGV[3] end


cyphertext = File.read(encrypted_path)

enigma = Enigma.new()
decryption_hash = enigma.decrypt(cyphertext, key, date)

new_file = File.open(decrypted_path, "w")
new_file.write(decryption_hash[:decryption])
new_file.close

puts "Created '#{decrypted_path}' with the key #{decryption_hash[:key]} and date #{decryption_hash[:date]}"
