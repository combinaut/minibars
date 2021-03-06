RSpec.describe Minibars::Context do
  subject(:context) { described_class.new }

  describe '#new' do
    it 'should optionally accept a file for loading the handlebars runtime from' do
      context = described_class.new(handlebars_file: Handlebars::Source.bundled_path)

      expect(context).to be_an_instance_of described_class
    end
  end

  describe '#compile' do
    it 'should compile a handlebars template string into a Minibars::Template' do
      expect(context.compile('Hello {{ name }}')).to be_an_instance_of Minibars::Template
    end

    it 'should compile handlebars templates that contain new lines' do
      expect(context.compile("Hello \n {{ name }}").call(name: 'Jason')).to eq "Hello \n Jason"
    end
  end

  describe '#register_partial' do
    it 'should add partials to the context' do
      context.register_partial('testing', 'Testing... 1-2-3')

      expect(context.compile('{{> testing }}').call).to eq 'Testing... 1-2-3'
    end
  end

  describe '#load_helpers' do
    it 'should add helpers from a file glob' do
      context.load_helpers("#{__dir__}/helpers/*.js")

      expect(context.compile('Hello {{shout name}}!').call(name: 'Jane')).to eq 'Hello JANE!'
    end
  end

  describe '#load_helper' do
    it 'should add a helper from a file' do
      context.load_helper(File.join("#{__dir__}/helpers/shout.js"))

      expect(context.compile('Hello {{shout name}}!').call(name: 'Jane')).to eq 'Hello JANE!'
    end
  end
end
