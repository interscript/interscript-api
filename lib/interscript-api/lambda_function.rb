require "json"
require_relative "graphql/schema"

def handler(event:, context: {})
  headers = {
    "Access-Control-Allow-Origin" => "https://www.interscript.com",
    "Access-Control-Allow-Headers" => "Content-Type",
    "Access-Control-Allow-Methods" => "OPTIONS,POST"
  }

  if event["body"].nil? || event["body"].empty?
    return {
      statusCode: 200,
      headers: headers,
    }
  end

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
  {
    statusCode: 400,
    headers: headers,
    body: e.message
  }
end
