require "json"
require_relative "graphql/schema"

def handler(event:, context:)
  query = event["body"]
  begin
    query = JSON.parse query
    query = query["query"]
  rescue JSON::ParserError
    # ignore
  end

  # headers = {
  #   "Access-Control-Allow-Headers" : "Content-Type",
  #   "Access-Control-Allow-Origin": "https://www.example.com",
  #   "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
  # }

  body = InterscriptApi::Schema.execute(query).to_json

  {
    statusCode: 200,
    body: body,
  }
rescue StandardError => e
  puts e.backtrace.inspect
  {
    statusCode: 400,
    body: e.message
  }
end
