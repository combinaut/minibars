RSpec.describe Minibars::Context do
  subject(:context) { described_class.new }

  context '#compile' do
    it 'should compile a handlebars template string into a Minibars::Template' do
      expect(context.compile('Hello {{ name }}')).to be_an_instance_of Minibars::Template
    end
  end
end
