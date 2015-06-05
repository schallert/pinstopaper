source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Asset stuff
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'   # JS compressor
gem 'font-awesome-rails', :git => 'git://github.com/bokmann/font-awesome-rails.git', :ref => '50d0eabe362f26bf0dad99b1ccae24d4bc22f7f1'
gem 'therubyracer'

gem 'figaro'

gem 'devise'
gem 'active_model_serializers'

# Memcached Stuff
gem 'dalli'
gem 'kgio'

gem 'pinboard'
gem 'faraday'

# Group specific gems
group :test do
  gem 'factory_girl_rails'
  gem 'turn', '~> 0.9.0'
end

group :development do
  gem 'sqlite3'
  gem 'thin'
  gem 'quiet_assets'
  gem 'debugger'
  gem 'capistrano'
end

group :production do
  gem 'unicorn'
  gem 'mysql2'
  gem 'activerecord-mysql-adapter'
end
