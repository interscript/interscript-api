lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "version"
require "rake"

Gem::Specification.new do |spec|
  spec.name = "interscript-api"
  spec.version = InterscriptApi::VERSION
  spec.required_rubygems_version = Gem::Requirement.new(">= 2.4.0") if spec.respond_to? :required_rubygems_version=

  spec.summary = "Interoperable script API"
  spec.description = "Interoperable script API"
  spec.authors = ["project_contibutors"]
  spec.license = "MIT"

  spec.files = FileList["{bin,lib,spec,maps}/**/*", "README.adoc"].to_a
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "debase"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pycall"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rambling-trie"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "ruby-debug-ide"
end
