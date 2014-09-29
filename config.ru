require './app'

use Rack::CommonLogger
run App.new # or just `run App`
