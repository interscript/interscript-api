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

    it "should print system_codes" do
      ENV['INTERSCRIPT_STAGING'] = '1'
      event = {
        "body" => '{systemCodes}'
      }
      rs = handler(event: event)
      rs = JSON.parse(rs[:body])["data"].to_h
      rs["systemCodes"].each { |i| expect(i).to be_a String }
    end
  end

  context "Cross origin input" do
    it "should match origin check" do
      cors_origin = "^(https?:\\/\\/(localhost:(.*)|(.*)boppi.website))$"

      rs = /#{cors_origin}/ =~ "https://boppi.website"
      expect(rs).to be_truthy

      rs = /#{cors_origin}/ =~ "https://api.boppi.website"
      expect(rs).to be_truthy

      rs = /#{cors_origin}/ =~ "https://localhost:3000"
      expect(rs).to be_truthy

      rs = /#{cors_origin}/ =~ "https://localhost:3001"
      expect(rs).to be_truthy

    end
  end
end
