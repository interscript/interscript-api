require "json"
require_relative "graphql/schema"

def handler(event:, context:)
  headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
    "Access-Control-Allow-Methods": "OPTIONS,POST"
  }

  query = event["body"]

  begin
    query = JSON.parse query
    query = query["query"]
  rescue JSON::ParserError
    # ignore
  end

  body = InterscriptApi::Schema.execute(query).to_json

  {
    statusCode: 200,
    headers: headers,
    body: body,
  }
rescue StandardError => e
  return {
    statusCode: 200,
    headers: headers,
  } if event["body"].nil? || event["body"].empty?

  puts e.backtrace.inspect
  {
    statusCode: 400,
    headers: headers,
    body: e.message
  }
end
