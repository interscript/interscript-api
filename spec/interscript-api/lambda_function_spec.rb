require 'interscript-api/lambda_function'


describe InterscriptApi do

  context 'With valid input' do

    it 'should return list of system_codes' do
      # test_string = 'uuu'
      # expect(test_string).to_not be_empty
      lambda = InterscriptApi::LambdaFunction.new

      event = {}
      context = {}
      rs = InterscriptApi::LambdaFunction.process(event: event, context: context)
      expect(rs).to eql('hello')
    end

  end
end
