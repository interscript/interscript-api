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
          body: JSON.generate({ result: result }),
        }
      rescue StandardError => e
        rs = {
          statusCode: 500,
          body: JSON.generate({ errorMessage: "InvalidSystemError: #{e.inspect}" }),
        }
      end

      rs
    end

    def self.get_system_codes(event:, context:)
      spec = Gem::Specification.find_by_name("interscript")
      gem_root = spec.gem_dir

      maps_root = "#{gem_root}/maps"
      system_codes = Dir.entries(maps_root).
        select { |file| file.end_with?(".yaml") }.
        map { |file| File.basename(file, ".yaml") }

      {
        statusCode: 200,
        body: JSON.generate({ result: system_codes }),
      }
    end

    def self.get_system_limits(event:, context:)
      limits = {
        message_size_max: 100000,
        processing_time_max: 15000,
      }

      {
        statusCode: 200,
        body: JSON.generate({ result: limits }),
      }
    end
  end
end

#in this case, the handler setting is source.LambdaFunctions::Handler.process.
