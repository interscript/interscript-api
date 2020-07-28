require_relative 'types/query_type'

module InterscriptApi
  class Schema < GraphQL::Schema
    query QueryType
  end
end
