source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

gem 'rails_12factor', group: :staging

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise', '~> 3.5.2'
gem 'cancancan', '~> 1.13.1'

gem "nested_form", '~> 0.3'

# For Pagination
gem 'kaminari', '~> 0.16'

# For omniauth
gem 'omniauth', '~> 1.3'
gem 'omniauth-facebook', '~> 3.0'

# For Facebook graph api
gem 'koala', '~> 2.2'

# For Image
gem 'cloudinary', '~> 1.1'

# For Tags (Animals)
gem 'acts-as-taggable-on', '~> 3.5'

# For categories
gem 'awesome_nested_set', '~> 3.0'

# For permalink Urls
gem 'friendly_id', '~> 5.1'

# For comments
gem 'acts_as_commentable_with_threading', '~> 2.0'

# For state machine
gem 'state_machine', '~> 1.2'

# For Postgres fulltext search
gem 'pg_search', '~> 1.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'letter_opener', '~> 1.3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem "capistrano", "~> 3.4"
  gem 'capistrano-passenger', '~> 0.2'
  gem 'capistrano-bundler', '~> 1.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'
end

# mailboxer and faye gem for private mesaging
# https://github.com/cmer/socialization
