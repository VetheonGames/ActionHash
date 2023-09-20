# frozen_string_literal: true

require_relative 'lib/actionhash/version'

Gem::Specification.new do |spec|
  spec.name = 'actionhash'
  spec.version = Actionhash::VERSION
  spec.authors = ['PixelRidge Softworks']
  spec.email = ['ceo@pixelridgesoftworks.com']

  spec.summary = 'A custom hash mechanism for action tracking and validation.'
  spec.description = 'ActionHash is a Ruby gem designed to validate a series of actions while obfuscating the associated
                      data. Its particularly useful in scenarios where you want to ensure the integrity of a sequence of
                      actions or data points, such as in gaming, financial transactions, IoT devices, and more. Please
                      go to the homepage for more information about how to use this gem!'
  spec.homepage = 'https://git.pixelridgesoftworks.com/PixelRidge-Softworks/ActionHash'
  spec.license = 'PixelRidge-BEGPULSE'
  spec.required_ruby_version = '>= 3.2.2'

  spec.metadata['allowed_push_host'] = 'https://git.pixelridgesoftworks.com/api/packages/PixelRidge-Softworks/rubygems'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://git.pixelridgesoftworks.com/PixelRidge-Softworks/ActionHash'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
