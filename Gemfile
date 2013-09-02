source 'https://rubygems.org'

gemspec

gem 'rails', '~> 4.0.0'

# Add support for refinerycms-acts-as-indexed
gem 'refinerycms-acts-as-indexed', github: 'refinery/refinerycms-acts-as-indexed'

gem 'protected_attributes'
gem 'seo_meta', github: 'parndt/seo_meta', branch: 'master'

# Fixes uniqueness constraint on translated columns.
# See: https://github.com/svenfuchs/globalize3/pull/121
gem 'globalize3', github: 'svenfuchs/globalize3'
gem 'paper_trail', github: 'parndt/paper_trail', branch: 'rails4'
gem 'devise', '~> 3.0.2'
gem 'awesome_nested_set', github: 'collectiveidea/awesome_nested_set', branch: 'master'
gem 'orm_adapter', github: 'ugisozols/orm_adapter', branch: 'rails4'
gem 'database_cleaner', github: "ugisozols/database_cleaner", branch: 'rails4'
gem 'routing-filter', github: "refinery/routing-filter", branch: 'rails4'

# Database Configuration
unless ENV['TRAVIS']
  gem 'activerecord-jdbcsqlite3-adapter', platform: :jruby
  gem 'sqlite3', platform: :ruby
end

unless ENV['TRAVIS'] && ENV['DB'] != 'mysql'
  gem 'activerecord-jdbcmysql-adapter', platform: :jruby
  gem 'mysql2', platform: :ruby
end

unless ENV['TRAVIS'] && ENV['DB'] != 'postgresql'
  gem 'activerecord-jdbcpostgresql-adapter', platform: :jruby
  gem 'pg', platform: :ruby
end

gem 'jruby-openssl', platform: :jruby

group :test do
  gem 'refinerycms-testing', '~> 3.0.0.dev'
  gem 'generator_spec', '~> 0.9.0'
  gem 'launchy'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier', '>= 1.0.3', require: false
end

# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path('../.gemfile', __FILE__)
  eval File.read(local_gemfile)
end
