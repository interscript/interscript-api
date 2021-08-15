source "https://rubygems.org"

ruby RUBY_VERSION

gem "graphql", "~>1.9"

unless ENV['INTERSCRIPT_GEM_VERSION'].empty? then
  gem "interscript", ENV['INTERSCRIPT_GEM_VERSION']
else
  gem "interscript", "0.1.9"
end

group :development do
  gem "rake"
  gem "rspec"
end

gem 'rababa', github: 'interscript/rababa', ref: '70051da'
