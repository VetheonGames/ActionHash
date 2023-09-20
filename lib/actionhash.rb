# frozen_string_literal: true

require_relative 'actionhash/version'
require 'securerandom'

module ActionHash
  class Error < StandardError; end

  @key_usage_count = {}
  MAX_ACTIONS_PER_KEY = 10

  # Generate a new key
  def self.generate_new_key
    SecureRandom.hex(8)
  end

  # Create a new Action Hash
  def self.create(prev_hash, input_data, key)
    # Check if the key has reached its limit
    @key_usage_count[key] ||= 0
    if @key_usage_count[key] >= MAX_ACTIONS_PER_KEY
      raise Error, 'Key has reached its maximum usage. Please generate a new key.'
    end

    data = [prev_hash, input_data].join(',')
    puts "Debug: Creating hash with prev_hash=#{prev_hash}, input_data=#{input_data}, key=#{key}"
    puts "Concatenated data before encryption: #{data}"
    encrypted_data = xor_encrypt(data, key)
    encrypted_hex = encrypted_data.unpack1('H*') # Convert to hex
    puts "Encrypted hex: #{encrypted_hex}"

    # Increment the usage count for the key
    @key_usage_count[key] += 1

    encrypted_hex
  end

  # Decrypt an Action Hash to its components
  def self.down_layer(hash, key)
    puts "Debug: Decrypting hash=#{hash} with key=#{key}"
    hex_decoded = [hash].pack('H*') # Convert from hex
    decrypted_data = xor_encrypt(hex_decoded, key)
    puts "Decrypted data: #{decrypted_data}"
    prev_hash, input_data = decrypted_data.split(',')
    { prev_hash: prev_hash.to_s, input_data: input_data.to_s }
  end

  # XOR encrypt/decrypt (symmetric)
  def self.xor_encrypt(data, key)
    data.bytes.zip(key.bytes.cycle).map { |a, b| (a ^ b).chr }.join
  end

  # Validate if a hash can be traced back to '0'
  def self.valid_hash?(hash, key, level = 20)
    current_level = 0
    loop do
      puts "Debug: Validating hash=#{hash} with key=#{key} at level=#{current_level}"
      return false if current_level >= level

      decrypted_data = down_layer(hash, key)
      return true if decrypted_data[:prev_hash] == '0'
      return false if decrypted_data[:prev_hash].nil? || decrypted_data[:prev_hash].empty?

      hash = decrypted_data[:prev_hash]
      current_level += 1
    end
  end
end
