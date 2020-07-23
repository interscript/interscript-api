require "graphql"
require_relative "../models/post"
require_relative "post_type"

class QueryType < GraphQL::Schema::Object
  description "Root Query for this API"

  # field :systemCodes, String, null: true do
  #   description "Get all current supported system_codes"
  # end
  #
  # def systemCodes
  #   "system_code 1"
  # end

  # fields should be queried in camel-case (this will be `truncatedPreview`)
  # field :truncated_preview, String, null: false

  field :system_codes, String, null: true do
    description "Get all current supported system_codes"
  end

  def system_codes
    "system_code 2"
  end

  # First describe the field signature:
  field :post, Types::PostType, null: true do
    description "Find a post by ID"
    argument :id, ID, required: true
  end

  # Then provide an implementation:
  def post(id:)
    #Post.find(id)
    Post.find(id)
  end
end

