# frozen_string_literal: true

require_relative "types/query"

module InterscriptApi
  module GraphQL
    class Schema < ::GraphQL::Schema
      query Types::Query
    end
  end
end
