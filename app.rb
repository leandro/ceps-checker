require 'hobbit'
require 'sqlite3'
require './lib/cep_base.rb'

class App < Hobbit::Base
  get '/:cep' do
    CEPBase.include?(request.params[:cep]) ? '1' : '0'
  end
end
