require './lib/enigma'
require 'date'
require './lib/helper_methods'

include HelperMethods

message_path = ARGV[0]
encrypted_path = ARGV[1]
if ARGV[2] == nil then key = random_key else key = ARGV[2] end
if ARGV[3] == nil then date = today else date = ARGV[3] end


message = File.read(message_path)

enigma = Enigma.new()
encryption_hash = enigma.encrypt(message, key, date)

new_file = File.open(encrypted_path, "w")
new_file.write(encryption_hash[:encryption])
new_file.close

puts "Created '#{encrypted_path}' with the key #{encryption_hash[:key]} and date #{encryption_hash[:date]}"
