require "graphql"
require_relative "../../../limits"

class QueryType < GraphQL::Schema::Object
  description "Root Query for this API"

  field :limits, String, null: true do
    description "Get all current supported system_codes"
  end

  field :system_codes, [String], null: true do
    description "Get all current supported system_codes"
  end

  def limits
    JSON.generate InterscriptApi::LIMITS
  end

  def system_codes
    spec = Gem::Specification.find_by_name("interscript")
    gem_root = spec.gem_dir
    puts gem_root

    maps_root = "#{gem_root}/maps"
    Dir.entries(maps_root).
      select { |file| file.end_with?(".yaml") }.
      map { |file| File.basename(file, ".yaml") }
  end
end


