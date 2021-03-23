ENV['RAILS_ENV'] ||= 'test'

require 'bundler'
Bundler.require :default, :development

require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!

ENGINE_RAILS_ROOT = File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
end
