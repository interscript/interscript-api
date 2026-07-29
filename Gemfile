source "https://rubygems.org"

ruby ">= 3.3.0"

gem "graphql", "~> 1.13"

if ENV["INTERSCRIPT_GEM_VERSION"] && !ENV["INTERSCRIPT_GEM_VERSION"].empty?
  gem "interscript", ENV["INTERSCRIPT_GEM_VERSION"]
else
  gem "interscript", "0.1.9"
end

gem "rababa", "~> 0.1.1"

group :development, :test do
  gem "rake"
  gem "rspec", "~> 3.13"
  gem "standard", require: false
end
