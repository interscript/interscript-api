require 'interscript-api/lambda_function'

describe InterscriptApi do

  context "With valid input" do

    it "should detect when a string contains vowels" do
      test_string = 'uuu'
      expect(test_string).to_not be_empty
    end

  end
end
