# frozen_string_literal: true

require_relative 'lib/rubocop/infinum/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop-infinum'
  spec.version       = RuboCop::Infinum::VERSION
  spec.authors       = ['Marko Ćilimković', 'Stjepan Hađić', 'Tin Benaković']
  spec.email         = ['team.backend@infinum.com']

  spec.summary       = 'Automatic Infinum code style checking tool.'
  spec.homepage      = 'https://github.com/infinum/rubocop-infinum'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.5'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/infinum/rubocop-infinum'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency('pry-byebug', '< 4')
  spec.add_development_dependency('rspec', '~> 3.9')

  spec.add_runtime_dependency('rubocop', '>= 1.28.0')
  spec.add_runtime_dependency('rubocop-rails')
  spec.add_runtime_dependency('rubocop-rspec')
  spec.add_runtime_dependency('rubocop-performance')
end
