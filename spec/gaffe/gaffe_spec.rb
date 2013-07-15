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

    describe :errors_controller do
      context 'with custom-defined controller' do
        before do
          Gaffe.configure do |config|
            config.errors_controller = :foo
          end
        end

        let(:controller) { Gaffe.errors_controller }
        it { expect(controller).to eql :foo }
      end

      context 'without custom-defined controller' do
        let(:controller) { Gaffe.errors_controller }
        it { expect(controller).to eql Gaffe::ErrorsController }
      end
    end
  end
end
