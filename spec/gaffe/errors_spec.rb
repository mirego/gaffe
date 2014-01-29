require 'spec_helper'

describe Gaffe::Errors do
  describe :Actions do
    describe :show do
      let(:request) { ActionDispatch::TestRequest.new }
      let(:env) { request.env.merge 'action_dispatch.exception' => exception }

      let(:response) { Gaffe.errors_controller_for_request(env).action(:show).call(env) }
      subject { response.last }

      context 'with builtin exception' do
        let(:exception) { ActionController::RoutingError.new(:foo) }
        its(:status) { should eql 404 }
        its(:body) { should match(/Not Found/) }
      end

      context 'with custom exception and missing view' do
        before { ActionDispatch::ExceptionWrapper.rescue_responses.merge! exception_class.name => 'my_custom_error' }

        let(:exception_class) do
          Object.instance_eval { remove_const :MyCustomError } if Object.const_defined?(:MyCustomError)
          MyCustomError = Class.new(StandardError)
        end

        let(:exception) { exception_class.new }
        its(:status) { should eql 500 }
        its(:body) { should match(/Internal Server Error/) }
      end
    end
  end
end
