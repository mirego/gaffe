require 'spec_helper'

describe Gaffe do
  describe :ClassMethods do
    describe :configure do
      let(:configuration) { Gaffe.configuration }
      before do
        Gaffe.configure do |config|
          config.foo = :bar
          config.bar = :foo
        end
      end

      it { expect(configuration.foo).to eql :bar }
      it { expect(configuration.bar).to eql :foo }
    end

    describe :enable! do
      let(:env) { test_request.env }
      let(:action_double) { double(call: proc { [400, {}, 'SOMETHING WENT WRONG.'] }) }
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
