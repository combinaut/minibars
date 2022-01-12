RSpec.describe Minibars::Template do
  subject(:template) { Minibars::Context.new.compile('Hello {{ name }}') }

  context '#call' do
    it 'should take parameters to fill template variables' do
      expect(template.call(name: 'Peter')).to eq 'Hello Peter'
    end

    it 'should take no parameters' do
      expect(template.call).to eq 'Hello '
    end
  end
end
