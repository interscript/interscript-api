# frozen_string_literal: true

require "json"
require_relative "graphql/schema"
require_relative "lambda/cors"
require_relative "lambda/request_parser"
require_relative "lambda/response_builder"
require "bundler/setup"

# AWS Lambda entry point. Thin orchestrator: parses the request, dispatches
# to the GraphQL schema, shapes the response. Each concern lives in its
# own module so the orchestration here stays readable and individually
# testable.
module InterscriptApi
  module Lambda
    module_function

    def handler(event:, context: {})
      headers = Cors.headers_for(event: event)

      return ResponseBuilder.options(headers: headers).to_h if options_request?(event)

      query = RequestParser.extract_query(body: event["body"])
      return ResponseBuilder.options(headers: headers).to_h if query.nil?

      result, status = execute(query)
      status = ResponseBuilder.status_for(result_body: result, fallback: status)

      ResponseBuilder.build(status: status, body: result, headers: headers)
    end

    # Runs the query through the schema. Returns [result_string, status_code].
    def execute(query)
      [InterscriptApi::GraphQL::Schema.execute(query).to_json, ResponseBuilder::DEFAULT_OK_STATUS]
    rescue InterscriptApi::Error => e
      warn(e.message)
      [e.message, ResponseBuilder::DEFAULT_BAD_REQUEST_STATUS]
    rescue StandardError => e
      warn(e.message)
      warn(e.backtrace.first(5).join("\n")) if e.backtrace
      [e.message, ResponseBuilder::DEFAULT_BAD_REQUEST_STATUS]
    end

    def options_request?(event)
      event["httpMethod"] == "OPTIONS"
    end
  end
end

# Backwards-compatible top-level entry point. Existing Lambda configurations
# reference `lib/interscript-api/lambda_function.handler`.
def handler(event:, context: {})
  InterscriptApi::Lambda.handler(event: event, context: context)
end
