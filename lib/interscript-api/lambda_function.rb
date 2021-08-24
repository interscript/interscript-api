require "json"
require_relative "graphql/schema"
require "bundler/setup"

def handler(event:, context: {})
  cors_origin = ENV["DEFAULT_ORIGIN"]
  input_origin = event.fetch('headers', {}).fetch('origin', "")

  if /#{ENV["CORS_ORIGIN_REGEX"]}/ =~ input_origin
    puts 'match origin'
    cors_origin = input_origin
  end

  headers = {
    "Access-Control-Allow-Origin" => cors_origin,
    "Access-Control-Allow-Headers"=> 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
    "Access-Control-Allow-Methods"=> "POST, OPTIONS"
  }

  body = event['body']
  if "OPTIONS".casecmp?(event['httpMethod']) || body.nil? || body.empty?
    return {
      statusCode: 200,
      headers: headers,
    }
  end

  puts "123 hardcode rababa for testing"
  ENV['RABABA_DATA']='/tmp'

  query = begin
            JSON.parse(body)["query"]
          rescue JSON::ParserError
            body
          end

  status_code = begin
                  result = InterscriptApi::Schema.execute(query).to_json
                  200
                rescue StandardError => e
                  result = e.message
                  400
                end

  begin
    result_json = JSON.parse result
    status_code = 400 if result_json.key?("errors")
  rescue JSON::ParserError
    #ignore
  end

  puts "123 1"
  {
    statusCode: status_code,
    headers: headers,
    body: result
  }
end
