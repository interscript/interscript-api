# frozen_string_literal: true

require "json"

module InterscriptApi
  module Lambda
    # Builds CORS-aware response headers based on the request origin.
    #
    # Separated from the handler so CORS rules can be tested independently
    # of the GraphQL execution path.
    module Cors
      DEFAULT_HEADERS = {
        "Access-Control-Allow-Origin" => "*",
        "Access-Control-Allow-Headers" => "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
        "Access-Control-Allow-Methods" => "POST, OPTIONS"
      }.freeze

      module_function

      def headers_for(event:)
        default_origin = ENV.fetch("DEFAULT_ORIGIN", "*")
        regex = ENV["CORS_ORIGIN_REGEX"]
        origin = event.fetch("headers", {}).fetch("origin", "")

        if regex && !regex.empty? && origin && /#{regex}/.match?(origin)
          DEFAULT_HEADERS.merge("Access-Control-Allow-Origin" => origin)
        else
          DEFAULT_HEADERS.merge("Access-Control-Allow-Origin" => default_origin)
        end
      end
    end
  end
end
