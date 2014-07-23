require_relative "../../bomb_interface.rb"

require "Capybara"
require "Capybara/cucumber"
require "rspec"

World do
  Capybara.app = Sinatra::Application
end
