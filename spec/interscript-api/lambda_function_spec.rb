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

    # it "should return list of system_codes" do
    #   rs = handler(event: nil , context: nil)
    #   rs = JSON.parse(rs["body".to_sym])["result"]
    #   puts rs
    # end
  end
end
