require 'swagger_helper'

RSpec.describe 'Health API', type: :request do
  path '/health' do
    get 'Health check' do
      tags 'Health'
      produces 'application/json'

      response '200', 'health check' do
        run_test!
      end
    end
  end
end