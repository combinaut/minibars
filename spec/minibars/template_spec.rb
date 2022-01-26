RSpec.describe Minibars::Template do
  subject(:template) { Minibars::Context.new.compile('Hello {{ name }}') }

  describe '#call' do
    it 'should take parameters to fill template variables' do
      expect(template.call(name: 'Peter')).to eq 'Hello Peter'
    end

    it 'should take no parameters' do
      expect(template.call).to eq 'Hello '
    end

    it 'should accept functions as parameter values' do
      expect(template.call(name: ->{ 'Mary' * 3 })).to eq 'Hello MaryMaryMary'
    end
  end
end
