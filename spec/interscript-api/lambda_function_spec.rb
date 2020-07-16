require "interscript-api/lambda_function"
require "json"

describe InterscriptApi do

  context "With valid input" do

    it "should return valid data" do
      event = {}
      event["body"] = JSON.generate(
        {
          system_code: "un-mon-Mong-Latn-2013",
          input: "a",
        },
      )
      context = {}
      rs = InterscriptApi::LambdaFunction.process_system_code(event: event, context: context)
      rs = JSON.parse(rs["body".to_sym])
      expect(rs["result"]).to eql("a")
    end

    it "should return list of system_codes" do
      rs = InterscriptApi::LambdaFunction.get_system_codes(event: nil , context: nil)
      rs = JSON.parse(rs["body".to_sym])["result"]
      puts rs
    end
  end
end
