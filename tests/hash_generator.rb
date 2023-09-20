# frozen_string_literal: true

require 'actionhash' # Update this path to where your ActionHash module is located

class ActionHashTest
  def initialize
    @keys = [ActionHash.generate_new_key] # Initialize an array to store keys
    puts "Generated key: #{@keys.last}"
    @hashes = []
    @action_count = 0
  end

  def run_test(depth)
    prev_hash = '0'
    data = 30

    depth.times do |i|
      puts "Layer #{i + 1}:"

      # Check if the key has reached its limit and generate a new one if necessary
      if @action_count >= ActionHash::MAX_ACTIONS_PER_KEY
        @keys << ActionHash.generate_new_key # Generate and store a new key
        puts "Generated new key: #{@keys.last}"
        @action_count = 0
        prev_hash = '0' # Reset prev_hash for the new key
      end

      current_key = @keys.last # Use the last key in the array
      new_hash = ActionHash.create(prev_hash, data.to_s, current_key)
      puts "Generated hash: #{new_hash}"
      @hashes << { hash: new_hash, key: current_key }
      prev_hash = new_hash
      data *= 2

      @action_count += 1
    end

    validate_hashes
  end

  def validate_hashes
    puts "\nValidating hashes..."
    all_valid = true
    prev_hash = '0' # Initialize prev_hash to '0' as in the run_test method
    current_key_index = 0 # Initialize index to keep track of the current key

    @hashes.each_with_index do |hash_data, index|
      hash = hash_data[:hash]
      key = hash_data[:key]

      # Check if we need to switch to the next key
      if current_key_index < @keys.length - 1 && key != @keys[current_key_index]
        current_key_index += 1
        prev_hash = '0' # Reset prev_hash for the new key
      end

      decrypted_data = ActionHash.down_layer(hash, key)
      puts "Decrypted data: #{decrypted_data[:prev_hash]},#{decrypted_data[:input_data]}"
      puts "Current level: #{index + 1}"
      puts "Current hash: #{hash}"

      if decrypted_data[:prev_hash] != prev_hash
        puts "Hash at level #{index + 1} is invalid."
        all_valid = false
        break
      end

      prev_hash = hash # Update prev_hash for the next iteration
    end

    puts all_valid ? 'All hashes are valid.' : 'Hash validation failed.'
  end
end

if ARGV.length != 1 || !ARGV[0].match?(/^\d+$/)
  puts "Usage: ruby #{__FILE__} [depth]"
  exit 1
end

depth = ARGV[0].to_i
test = ActionHashTest.new
test.run_test(depth)
