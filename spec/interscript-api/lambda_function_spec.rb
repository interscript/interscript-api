require "interscript-api/lambda_function"
require "json"

describe InterscriptApi do

  context "With valid input" do

    it "should return valid data" do
      event = {}
      event["body"] = '{transliterate(systemCode: "bgnpcgn-arm-Armn-Latn-1981", input: "testing")}'
      context = {}
      rs = handler(event: event, context: context)
      rs = JSON.parse(rs[:body])["data"]["transliterate"]
      expect(rs).to eql("testing")
    end
  end
end
