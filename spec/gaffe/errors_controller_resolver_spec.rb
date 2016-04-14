require 'spec_helper'

describe Gaffe::ErrorsControllerResolver do
  describe :resolved_controller do
    let(:resolver) { Gaffe::ErrorsControllerResolver.new(env) }
    let(:controller) { resolver.resolved_controller }
    let(:request) { test_request }
    let(:env) { request.env }

    context 'with custom-defined controller' do
      before do
        Gaffe.configure do |config|
          config.errors_controller = :foo
        end
      end

      it { expect(controller).to eql :foo }
    end

    context 'with custom-defined controller that respond to `#constantize`' do
      before do
        Gaffe.configure do |config|
          config.errors_controller = 'String'
        end
      end

      it { expect(controller).to eql String }
    end

    context 'with multiple custom-defined controllers' do
      before do
        Gaffe.configure do |config|
          config.errors_controller = {
            %r{^/web/} => :web_controller,
            %r{^/api/} => :api_controller,
            %r{^www.com} => :host_specific_controller
          }
        end
      end

      context 'with error coming from matching URL' do
        let(:env) { request.env.merge 'REQUEST_URI' => '/api/users' }
        it { expect(controller).to eql :api_controller }
      end

      context 'with error coming from matching HTTP_HOST' do
        let(:env) { request.env.merge('HTTP_HOST' => 'www.com', 'REQUEST_URI' => '/') }
        it { expect(controller).to eql :host_specific_controller }
      end

      context 'with errors coming from non-matching URL' do
        let(:env) { request.env.merge 'REQUEST_URI' => '/what' }
        it { expect(controller).to eql Gaffe::ErrorsController }
      end
    end

    context 'without custom-defined controller' do
      it { expect(controller).to eql Gaffe::ErrorsController }
    end
  end
end
