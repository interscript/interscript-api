require "interscript-api/lambda_function"
require "json"

describe InterscriptApi do

  context "With valid input" do

    it "should return valid data" do
      event = {
        "body" => '{transliterate(systemCode: "odni-rus-Cyrl-Latn-2015", input: "Михаил Тимофеевич Калашников")}'
      }
      rs = handler(event: event)
      rs = JSON.parse(rs[:body])["data"]["transliterate"]
      expect(rs).to eql("Mikhail Timofeyevich Kalashnikov")
    end
  end
end
