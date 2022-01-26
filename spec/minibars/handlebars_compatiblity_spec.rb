RSpec.describe Handlebars do
  describe "::Context" do
    it "should alias Minibars::Context" do
      expect(Handlebars::Context).to eq Minibars::Context
    end
  end

  describe "::SafeString" do
    it "should alias Minibars::SafeString" do
      expect(Handlebars::SafeString).to eq Minibars::SafeString
    end
  end
end