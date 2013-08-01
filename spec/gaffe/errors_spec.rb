require 'spec_helper'

describe Gaffe::Errors do
  describe :Actions do
    describe :show do
      let(:request) { ActionDispatch::TestRequest.new }
      let(:env) { request.env.merge 'action_dispatch.exception' => exception }
      let(:exception) { ActionController::RoutingError.new(:foo) }

      let(:response) { Gaffe.errors_controller_for_request(env).action(:show).call(env) }
      subject { response.last }

      its(:status) { should eql 404 }
      its(:body) { should match /Not Found/ }
    end
  end
end
