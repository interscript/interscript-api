require "interscript"
require "json"

module InterscriptApi

  class LambdaFunction

    def self.process_system_code(event:, context:)
      body = JSON.parse event["body"]

      system_code = body["system_code"]
      input = body["input"]

      puts "system: #{system_code}"
      puts "input: #{input}"

      begin
        result = Interscript.transliterate(system_code, input)

        rs = {
          statusCode: 200,
          body: JSON.generate(
            {
              result: result,
            },
          ),
        }
      rescue StandardError => e
        rs = {
          statusCode: 500,
          body: JSON.generate(
            {
              errorMessage: "InvalidSystemError: #{e.inspect}",
            },
          ),
        }
      end

      rs
    end
  end
end

#in this case, the handler setting is source.LambdaFunctions::Handler.process.
