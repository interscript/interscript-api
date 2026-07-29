# frozen_string_literal: true

require "graphql"
require "json"

require_relative "../../../limits"
require_relative "../../../version"
require_relative "../../../error"
require_relative "detection_result"

require "interscript"
require "interscript/compiler/ruby"

require "pathname" unless ENV["AWS_EXECUTION_ENV"].nil?

module InterscriptApi
  module GraphQL
    module Types
      class Query < ::GraphQL::Schema::Object
        description "Root Query for this API"

        # -- Fields declared via class-level DSL; new fields are added here
        # -- without modifying resolver methods of existing fields (OCP).

        field :info, String, null: true do
          description "Get API information"
        end

        field :system_codes, [String], null: true do
          description "Get all current supported system_codes"
        end

        field :transliterate, String, null: true do
          description "Transliterate the given input using the specified system_code"
          argument :system_code, String, required: true
          argument :input, String, required: true
        end

        field :detect, [DetectionResult], null: true do
          description "Detect which transliteration system was used for input to generate output"
          argument :input, String, required: true
          argument :output, String, required: true
          argument :map_pattern, String, required: false, default_value: "*"
        end

        # -- Resolvers (one method per field; no cross-coupling)

        def transliterate(system_code:, input:)
          unless input.length <= InterscriptApi::LIMITS[:input_max_size]
            raise InterscriptApi::InputTooLongError.new(max: InterscriptApi::LIMITS[:input_max_size])
          end

          Interscript.transliterate(
            system_code,
            input,
            query_cache,
            compiler: Interscript::Compiler::Ruby
          )
        end

        def detect(input:, output:, map_pattern: "*")
          Interscript.detect(
            input,
            output,
            compiler: Interscript::Compiler::Ruby,
            multiple: true,
            cache: query_cache,
            map_pattern: map_pattern
          ).map { |map_name, distance| {map_name: map_name, distance: distance} }
        end

        def info
          JSON.generate(
            version: InterscriptApi::VERSION,
            interscript_version: Interscript::VERSION
          )
        end

        def system_codes
          Interscript.maps
        end

        private

        # Per-request cache, lazily initialized. Lives on the resolver instance
        # for the lifetime of a single GraphQL execution.
        def query_cache
          @query_cache ||= {}
        end
      end
    end
  end
end
