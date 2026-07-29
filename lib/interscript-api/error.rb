# frozen_string_literal: true

module InterscriptApi
  class Error < StandardError; end

  class InputTooLongError < Error
    def initialize(max:)
      super("Input exceeds maximum length of #{max} characters")
      @max = max
    end

    attr_reader :max
  end
end
