require "interscript"
require "json"

module InterscriptApi

  class LambdaFunction

    # @param [Object] event
    # @param [Object] context
    # @return [Hash{Symbol->Integer}]
    def self.process(event:, context:)
      body = JSON.parse event["body"]

      system = body["system"]
      input = body["input"]

      puts "system: #{system}"
      puts "input: #{input}"

      # rs = { statusCode: 204 }

      begin
        result = Interscript.transliterate(system, input)

        rs = {
          statusCode: 200,
          body: JSON.generate(
            {
              result: result,
            },
          ),
        }
      rescue => error
        rs = {
          statusCode: 500,
          body: JSON.generate(
            {
              errorMessage: "InvalidSystemError: #{error.inspect}",
            },
          ),
        }
      end

      rs
    end
  end
end

#in this case, the handler setting is source.LambdaFunctions::Handler.process.
