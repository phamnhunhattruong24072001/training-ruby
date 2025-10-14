require 'swagger_helper'  # SỬA 'equire' THÀNH 'require'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    get 'List user' do
      tags 'Users'
      produces 'application/json'

      response '200', 'users found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string }
          },
          required: [ 'id', 'name' ]

        run_test!
      end
    end

    post 'Create a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'name', 'email', 'password' ]
      }

      response '201', 'user created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            email: { type: :string }
          },
          required: [ 'id', 'name', 'email' ]

        let(:user) { { name: 'John Doe', email: 'john@example.com', password: 'password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: 'John' } } # Missing required fields
        run_test!
      end
    end
  end
end