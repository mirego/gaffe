require 'spec_helper'

describe Gaffe do
  describe :ClassMethods do
    before do
      # Make sure we clear memoized variables before each test
      [:@errors_controller, :@configuration].each do |variable|
        Gaffe.send :remove_instance_variable, variable if Gaffe.instance_variable_defined?(variable)
      end
    end

    describe :configure do
      subject { Gaffe.configuration }
      before do
        Gaffe.configure do |config|
          config.foo = :bar
          config.bar = :foo
        end
      end

      its(:foo) { should eql :bar }
      its(:bar) { should eql :foo }
    end

    describe :errors_controller_for_request do
      let(:controller) { Gaffe.errors_controller_for_request(env) }
      let(:request) { ActionDispatch::TestRequest.new }
      let(:env) { request.env }

      context 'with custom-defined controller' do
        before do
          Gaffe.configure do |config|
            config.errors_controller = :foo
          end
        end

        it { expect(controller).to eql :foo }
      end

      context 'with multiple custom-defined controllers' do
        before do
          Gaffe.configure do |config|
            config.errors_controller = {
              %r[^/web/] => :web_controller,
              %r[^/api/] => :api_controller
            }
          end
        end

        context 'with error coming from matching URL' do
          let(:env) { request.env.merge 'REQUEST_URI' => '/api/users' }
          it { expect(controller).to eql :api_controller }
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
end
