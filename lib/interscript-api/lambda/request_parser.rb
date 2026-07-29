# frozen_string_literal: true

module InterscriptApi
  module Lambda
    # Extracts the GraphQL query string from a Lambda event body.
    #
    # Single responsibility: turn the raw event body into a query string,
    # accepting either a JSON `{"query": "..."}` envelope or a raw string.
    module RequestParser
      module_function

      def extract_query(body:)
        return nil if body.nil? || body.empty?

        json = begin
          JSON.parse(body)
        rescue JSON::ParserError
          nil
        end

        json.is_a?(Hash) ? json["query"] : body
      end
    end
  end
end
