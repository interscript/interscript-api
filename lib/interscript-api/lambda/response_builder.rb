# frozen_string_literal: true

require "json"

module InterscriptApi
  module Lambda
    # Shapes the result of GraphQL execution into a Lambda-compatible
    # response hash. Centralises status-code and body conventions so the
    # handler can stay focused on orchestration.
    module ResponseBuilder
      DEFAULT_OK_STATUS = 200
      DEFAULT_BAD_REQUEST_STATUS = 400

      def self.success(body:, headers:)
        new(status: DEFAULT_OK_STATUS, body: body, headers: headers)
      end

      def self.bad_request(body:, headers:)
        new(status: DEFAULT_BAD_REQUEST_STATUS, body: body, headers: headers)
      end

      def self.options(headers:)
        new(status: DEFAULT_OK_STATUS, body: nil, headers: headers)
      end

      def self.build(status:, body:, headers:)
        new(status: status, body: body, headers: headers).to_h
      end

      def self.status_for(result_body:, fallback: DEFAULT_OK_STATUS)
        parsed = JSON.parse(result_body)
        parsed.is_a?(Hash) && parsed.key?("errors") ? DEFAULT_BAD_REQUEST_STATUS : fallback
      rescue JSON::ParserError
        fallback
      end

      # Simple value object so callers can use either the convenience
      # constructors above (success / bad_request / options) or the raw
      # `build` factory with explicit status.
      Response = Struct.new(:status, :body, :headers) do
        def to_h
          h = {statusCode: status, headers: headers}
          h[:body] = body unless body.nil?
          h
        end
      end

      def self.new(status:, body:, headers:)
        Response.new(status, body, headers)
      end
      private_class_method :new
    end
  end
end
