require 'spec_helper'

describe Gaffe::Errors do
  describe :Actions do
    describe :show do
      let(:request) { ActionDispatch::TestRequest.new }
      let(:env) { request.env.merge 'action_dispatch.exception' => exception }

      let(:response) { Gaffe.errors_controller_for_request(env).action(:show).call(env).last }

      context 'with builtin exception' do
        let(:exception) { ActionController::RoutingError.new(:foo) }
        it { expect(response.status).to eql 404 }
        it { expect(response.body).to match(/Not Found/) }
      end

      context 'with custom exception and missing view' do
        before { ActionDispatch::ExceptionWrapper.rescue_responses.merge! exception_class.name => 'my_custom_error' }

        let(:exception_class) do
          Object.instance_eval { remove_const :MyCustomError } if Object.const_defined?(:MyCustomError)
          MyCustomError = Class.new(StandardError)
        end

        let(:exception) { exception_class.new }
        it { expect(response.status).to eql 500 }
        it { expect(response.body).to match(/Internal Server Error/) }
      end
    end
  end
end
