# ActionHash
If you need more direct help, join our [Discord](https://discord.gg/SQeWBWS8v4)

## Overview

ActionHash is a Ruby gem designed to validate a series of actions while obfuscating the associated data. It's particularly useful in scenarios where you want to ensure the integrity of a sequence of actions or data points, such as in gaming, financial transactions, IoT devices, and more.

> :warning: **Security Note**: While ActionHash does obfuscate data, it should not be considered a form of encryption. If someone gains access to the generated secret key, the hashes can be undone. Use this gem as a part of your security strategy, not as the sole mechanism for securing sensitive information.

## Installation

```bash
gem install actionhash
```

Or add it to your Gemfile:

```ruby
gem 'actionhash'
```

Then run:

```bash
bundle install
```

## Basic Usage

Here's a simple example to get you started:

```ruby
require 'actionhash'

# Initialize
keys = [ActionHash.generate_new_key]
hashes = []  # Array to store finished hashes
action_count = 0
prev_hash = '0'
data = "some_data"

# Create a hash
new_hash = ActionHash.create(prev_hash, data, keys.last)
hashes << new_hash  # Store the hash
```

### Validating a Hash

You can validate a hash using the `valid_hash?` method as follows:

```ruby
# Validate the hash
is_valid = ActionHash.valid_hash?(hashes.last, keys.last, 20)

if is_valid
  puts "Hash is valid."
else
  puts "Hash is invalid."
end
```

The `valid_hash?` method works by recursively decrypting the hash and checking if it reaches a base hash of '0'. It takes the hash, the key, and an optional level parameter to limit the depth of validation.

Here's the method definition for your reference:

```ruby
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
```

## Development Builds

For those interested in using development builds of ActionHash, you can install them directly from our Gem server hosted at PixelRidge Softworks.

Here's how you can install a development build:

```bash
gem install ActionHash --source "https://git.pixelridgesoftworks.com/api/packages/PixelRidge-Softworks/rubygems"
```

As an example, if you want to install a different gem from our Gem server, you can use the following command:

```bash
gem install Miniparser --source "https://git.pixelridgesoftworks.com/api/packages/PixelRidge-Softworks/rubygems"
```

