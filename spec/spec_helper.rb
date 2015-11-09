require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_group 'Libraries', 'lib'
end
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'toady'
require 'belafonte'
require 'belafonte/rspec'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
