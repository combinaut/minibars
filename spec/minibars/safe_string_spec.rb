RSpec.describe Minibars::SafeString do
  subject(:context) { Minibars::Context.new }
  
  it "should wrap a string and encode it as a handlebars safe string" do
    template = context.compile("{{safe}}")

    expect(template.call(safe: described_class.new("<p>Test</p>"))).to eq "<p>Test</p>"
    expect(template.call(safe: "<p>Test</p>")).to eq "&lt;p&gt;Test&lt;/p&gt;"
  end
end