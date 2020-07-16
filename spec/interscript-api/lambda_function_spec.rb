require "interscript-api/lambda_function"
require "json"

describe InterscriptApi do

  context "With valid input" do

    # system_code = "un-ben-Beng-Latn-2016"
    # mapping = Interscript::Mapping.for(system_code)
    #
    # expect(mapping.rules).to be_empty
    # expect(mapping.characters["অ"]).to eq("a")
    # expect(mapping.name).to eq("Bengali Romanization, Version 4.0")

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

  end
end
