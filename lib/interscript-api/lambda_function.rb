module InterscriptApi

  class LambdaFunction
    def self.process(event:, context:)
      "Hello!"
    end
  end
end

#in this case, the handler setting is source.LambdaFunctions::Handler.process.
