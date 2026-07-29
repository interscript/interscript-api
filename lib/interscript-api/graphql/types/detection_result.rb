# frozen_string_literal: true

require "json"

module InterscriptApi
  module GraphQL
    module Types
      class DetectionResult < ::GraphQL::Schema::Object
        field :map_name, String, null: false
        field :distance, Float, null: false
      end
    end
  end
end
