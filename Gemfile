source "https://rubygems.org"

# Ruby 4.0 readiness: target the latest stable 3.x line.
# Ruby 3.4 is the current stable line (Ruby 4.0 not yet released as of 2026-07).
# The codebase is audited to use no deprecated 3.x APIs.
ruby ">= 3.4"

gem "graphql", "~> 1.13"

if ENV["INTERSCRIPT_GEM_VERSION"] && !ENV["INTERSCRIPT_GEM_VERSION"].empty?
  gem "interscript", ENV["INTERSCRIPT_GEM_VERSION"]
else
  gem "interscript", "3.1.0"
end

gem "rababa", "~> 0.1.1"

group :development, :test do
  gem "rake"
  gem "rspec", "~> 3.13"
  gem "standard", require: false
end
