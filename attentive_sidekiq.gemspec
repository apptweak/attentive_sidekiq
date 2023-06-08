# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attentive_sidekiq/version'

Gem::Specification.new do |s|
  s.name        = 'apptweak-attentive_sidekiq'
  s.version     = AttentiveSidekiq::VERSION
  s.summary     = "Make your sidekiq to be attentive to lost jobs"
  s.description = "This gem allows you to watch the jobs which suddenly dissappeared from redis without being completed by redis worker"
  s.authors     = ["twonegatives"]
  s.email       = 'whitewhiteheaven@gmail.com'
  s.files       = Dir['**/*'].keep_if{ |file| File.file?(file) }
  s.test_files  = s.files.grep(%r{^(test|spec|features)/})
  s.homepage    = 'https://github.com/apptweak/attentive_sidekiq'
  s.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/'
    s.metadata['homepage_uri'] = s.homepage
    s.metadata['github_repo'] = s.homepage
    s.metadata['source_code_uri'] = s.homepage
    s.metadata['rubygems_mfa_required'] = 'false' # rubocop:disable Gemspec/RequireMFA
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  s.add_development_dependency 'sidekiq', '~> 4.2'
  s.add_development_dependency 'rake', '~> 11.3'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'minitest-stub_any_instance'
  s.add_development_dependency 'redis-namespace', '~> 1.5'
  s.add_development_dependency "rack-test", '~> 0.6'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency "pry-byebug"

  s.add_dependency "activesupport"
  s.add_dependency 'concurrent-ruby', '~> 1.0'
end
