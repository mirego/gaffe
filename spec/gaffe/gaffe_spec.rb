require 'spec_helper'

describe Gaffe do
  describe :ClassMethods do
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

    describe :enable! do
      let(:env) { ActionDispatch::TestRequest.new.env }
      let(:action_double) { double(call: lambda { |env| [400, {}, 'SOMETHING WENT WRONG.'] }) }
      before { Gaffe.enable! }

      specify do
        expect(Gaffe).to receive(:errors_controller_for_request).with(env).and_call_original
        expect(Gaffe::ErrorsController).to receive(:action).with(:show).and_return(action_double)
        expect(action_double).to receive(:call).with(env)

        # This is the line Rails itself calls
        # https://github.com/rails/rails/blob/fee49a10492efc99409c03f7096d5bd3377b0bbc/actionpack/lib/action_dispatch/middleware/show_exceptions.rb#L43
        Rails.application.config.exceptions_app.call(env)
      end
    end
  end
end
