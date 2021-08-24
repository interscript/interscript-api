require "graphql"
require_relative "../../../limits"
require_relative "../../../version"
require "interscript"
require "interscript/compiler/ruby"

require 'pathname' unless ENV["AWS_EXECUTION_ENV"].nil?

class DetectionResultType < GraphQL::Schema::Object
  field :map_name, String, null: false
  field :distance, Float, null: false
end

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

    rs = Interscript.transliterate(
      system_code,
      input.dup,
      @cache ||= {},
      compiler: Interscript::Compiler::Ruby
    )
    rs
  end

  field :detect, [DetectionResultType], null: true do
    description "Detect which transliteration system was used for #input to generate #output"
    argument :input, String, required: true
    argument :output, String, required: true

    argument :map_pattern, String, required: false, default_value: '*'
  end

  def detect(input:, output:, map_pattern: "*")
    rs = Interscript.detect(
      input,
      output,
      compiler: Interscript::Compiler::Ruby,
      multiple: true,
      cache: @cache ||= {},
      map_pattern: map_pattern
    ).map do |map_name, distance|
      { map_name: map_name, distance: distance }
    end

    rs
  end

  def info
    JSON.generate({
                    version: InterscriptApi::VERSION,
                    interscript_version: Interscript::VERSION,
                  })
  end

  # def limits
  #   JSON.generate InterscriptApi::LIMITS
  # end

  def system_codes
    Interscript.maps
  end
end


