# frozen_string_literal: true

require_relative 'actionhash/version'

# main module
module ActionHash
  class Error < StandardError; end

  # Create a new Action Hash
  def self.create(prev_hash, input_data, key)
    data = [prev_hash, input_data].join(',')
    encrypted_data = xor_encrypt(data, key)
    encrypted_data.unpack1('H*') # Convert to hex
  end

  # Decrypt an Action Hash to its components
  def self.down_layer(hash, key)
    hex_decoded = [hash].pack('H*') # Convert from hex
    decrypted_data = xor_encrypt(hex_decoded, key)
    prev_hash, input_data = decrypted_data.split(',')
    { prev_hash: prev_hash.to_i, input_data: input_data.to_i }
  end

  # XOR encrypt/decrypt (symmetric)
  def self.xor_encrypt(data, key)
    data.bytes.zip(key.bytes.cycle).map { |a, b| (a ^ b).chr }.join
  end
end
