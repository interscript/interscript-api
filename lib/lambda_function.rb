require 'interscript'
require 'json'


def handler(event:, context:)
  body = JSON.parse event['body']

  system = body['system']
  input = body['input']

  puts "system: #{system}"
  puts "input: #{input}"

  rs = {statusCode: 204}

  begin
    result = Interscript.transliterate(system, input)

    rs = {
        statusCode: 200,
        body: JSON.generate({
            :result => result
        })
    }
  rescue => error
    rs = {
        statusCode: 500,
        body: JSON.generate(
            {
                :errorMessage => "InvalidSystemError: #{error.inspect}"
            }
        )
    }
  end

  rs
end
