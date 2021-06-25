require "graphql"
require_relative "../../../limits"
require_relative "../../../version"
require "interscript"

require 'pathname' unless ENV["AWS_EXECUTION_ENV"].nil?


class QueryType < GraphQL::Schema::Object
  description "Root Query for this API"

  field :info, String, null: true do
    description "Get API information"
  end

  # field :limits, String, null: true do
  #   description "Get limits API information"
  # end

  field :system_codes, [String], null: true do
    description "Get all current supported system_codes"
  end

  field :transliterate, String, null: true do
    description "Transliterate #input using #system_code"
    argument :system_code, String, required: true
    argument :input, String, required: true
  end

  def transliterate(system_code:, input:)
    if input.length > InterscriptApi::LIMITS[:input_max_size]
      raise StandardError.new("{input} string too long")
    end

    Interscript.transliterate(system_code, input.dup)
  end

  def info
    # JSON.generate({
    #                 limit: InterscriptApi::LIMITS[:input_max_size],
    #                 interscript_version: InterscriptApi::INTERSCRIPT_VERSION
    #               })
    JSON.generate({
                    # limit: InterscriptApi::LIMITS[:input_max_size],
                    interscript_version: InterscriptApi::VERSION
                  })
  end

  # def limits
  #   JSON.generate InterscriptApi::LIMITS
  # end

  def system_codes
    # Interscript.map_locations
    # spec = Gem::Specification.find_by_name("interscript")
    # gem_root = spec.gem_dir
    #
    # maps_root = "#{gem_root}/maps"
    # maps_root = Interscript.map_aliases
    # Dir.entries(maps_root).
    #   select { |file| file.end_with?(".yaml") }.
    #   map { |file| File.basename(file, ".yaml") }
    ["not supported for now"]
  end
end


