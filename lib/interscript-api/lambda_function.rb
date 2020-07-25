# frozen_string_literal: true

require "json"
require_relative "graphql/schema"

def handler(event:, context:)
  puts "Received Request: #{event}"

  query = event["body"]
  body = InterscriptApi::Schema.execute(query).to_json

  {
    statusCode: 200,
    body: body,
  }
rescue StandardError => e
  puts e.message
  puts e.backtrace.inspect
  {
    statusCode: 400,
    body: JSON.generate("Bad request, please POST a request body!"),
  }
end
