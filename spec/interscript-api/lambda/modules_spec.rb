# frozen_string_literal: true

require "spec_helper"
require_relative "../../lib/interscript-api/lambda/cors"
require_relative "../../lib/interscript-api/lambda/request_parser"
require_relative "../../lib/interscript-api/lambda/response_builder"

RSpec.describe InterscriptApi::Lambda::Cors do
  describe ".headers_for" do
    after { ENV.delete("TEST_CORS_REGEX") }

    it "returns default headers when no regex configured" do
      ENV["DEFAULT_ORIGIN"] = "*"
      ENV["CORS_ORIGIN_REGEX"] = ""
      headers = described_class.headers_for(event: {"headers" => {"origin" => "https://example.com"}})
      expect(headers["Access-Control-Allow-Origin"]).to eq("*")
      expect(headers["Access-Control-Allow-Methods"]).to eq("POST, OPTIONS")
    end

    it "reflects origin when it matches the regex" do
      ENV["CORS_ORIGIN_REGEX"] = "example\\.com"
      headers = described_class.headers_for(event: {"headers" => {"origin" => "https://example.com"}})
      expect(headers["Access-Control-Allow-Origin"]).to eq("https://example.com")
    end

    it "falls back to default when origin does not match" do
      ENV["DEFAULT_ORIGIN"] = "https://default.test"
      ENV["CORS_ORIGIN_REGEX"] = "example\\.com"
      headers = described_class.headers_for(event: {"headers" => {"origin" => "https://other.test"}})
      expect(headers["Access-Control-Allow-Origin"]).to eq("https://default.test")
    end

    it "handles missing headers in event" do
      ENV["DEFAULT_ORIGIN"] = "*"
      ENV["CORS_ORIGIN_REGEX"] = ""
      headers = described_class.headers_for(event: {})
      expect(headers["Access-Control-Allow-Origin"]).to eq("*")
    end
  end
end

RSpec.describe InterscriptApi::Lambda::RequestParser do
  describe ".extract_query" do
    it "returns nil for nil body" do
      expect(described_class.extract_query(body: nil)).to be_nil
    end

    it "returns nil for empty body" do
      expect(described_class.extract_query(body: "")).to be_nil
    end

    it "extracts query from JSON envelope" do
      body = JSON.generate(query: "{ transliterate(systemCode: \"x\", input: \"y\") }")
      expect(described_class.extract_query(body: body))
        .to eq("{ transliterate(systemCode: \"x\", input: \"y\") }")
    end

    it "treats non-JSON body as raw query" do
      expect(described_class.extract_query(body: "{ raw graphql }"))
        .to eq("{ raw graphql }")
    end

    it "returns raw string when JSON is not an object" do
      expect(described_class.extract_query(body: "[1, 2, 3]")).to eq("[1, 2, 3]")
    end
  end
end

RSpec.describe InterscriptApi::Lambda::ResponseBuilder do
  describe ".success / .bad_request / .options" do
    it "success has 200 status" do
      r = described_class.success(body: "{}", headers: {})
      expect(r.status).to eq(200)
      expect(r.body).to eq("{}")
    end

    it "bad_request has 400 status" do
      r = described_class.bad_request(body: "err", headers: {})
      expect(r.status).to eq(400)
    end

    it "options omits body in to_h" do
      r = described_class.options(headers: {"X" => "y"})
      expect(r.to_h).to eq(statusCode: 200, headers: {"X" => "y"})
    end
  end

  describe ".status_for" do
    it "returns 400 when body has errors key" do
      body = JSON.generate(errors: [{"message" => "boom"}])
      expect(described_class.status_for(result_body: body, fallback: 200)).to eq(400)
    end

    it "returns fallback when body is non-error JSON" do
      body = JSON.generate(data: {"x" => 1})
      expect(described_class.status_for(result_body: body, fallback: 200)).to eq(200)
    end

    it "returns fallback when body is not parseable JSON" do
      expect(described_class.status_for(result_body: "Server Error", fallback: 200)).to eq(200)
    end
  end
end
