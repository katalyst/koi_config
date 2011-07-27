source "http://rubygems.org"

# Specify your gem's dependencies in koi_config.gemspec
gemspec

group :test do
  gem 'minitest'
  gem 'guard-minitest'
  gem 'purdytest'

  if Config::CONFIG['target_os'] =~ /darwin/i
    gem 'rb-fsevent', '>= 0.3.2'
    gem 'growl',      '~> 1.0.3'
  end

  if Config::CONFIG['target_os'] =~ /linux/i
    gem 'rb-inotify', '>= 0.5.1'
    gem 'libnotify',  '~> 0.1.3'
  end
end
