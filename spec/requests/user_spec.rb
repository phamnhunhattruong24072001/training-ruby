require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/api/v1/users' do
    get 'List users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'users found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  email: { type: :string },
                  username: { type: :string },
                  name: { type: :string },
                  phone: { type: :string }
                }
              }
            }
          }

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
          email: { type: :string },
          password: { type: :string },
          username: { type: :string },
          name: { type: :string },
          phone: { type: :string }
        },
        required: [ 'name', 'email', 'password', 'username' ]
      }

      response '201', 'user created' do
        schema type: :object,
          properties: {
            message: { type: :string },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                username: { type: :string },
                name: { type: :string },
                phone: { type: :string }
              }
            }
          }

        let(:user) { { name: 'John Doe', email: 'john@example.com', password: 'password', username: 'johndoe', phone: '123456789' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: 'John' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    get 'Show user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true, description: 'User ID'

      response '200', 'user found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            email: { type: :string },
            username: { type: :string },
            phone: { type: :string }
          }

        let(:id) { User.create(name: 'Test User', email: 'test@example.com', password: 'password').id }
        run_test!
      end

      response '404', 'user not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:id) { 99999 }
        run_test!
      end
    end

    put 'Update a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true, description: 'User ID'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          name: { type: :string },
          phone: { type: :string },
          email: { type: :string }
        },
        required: [ 'email', 'username' ]
      }

      response '200', 'user updated' do
        schema type: :object,
          properties: {
            message: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                username: { type: :string },
                name: { type: :string },
                phone: { type: :string }
              }
            }
          }

        let(:id) { User.create(name: 'Old Name', email: 'old@example.com', password: 'password', username: 'olduser', phone: '000000000').id }
        let(:user) { { name: 'John Doe', username: 'johndoe', phone: '123456789' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { User.create(name: 'Test', email: 'test@example.com', password: 'password').id }
        let(:user) { { username: '' } }
        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 99999 }
        let(:user) { { name: 'John Doe' } }
        run_test!
      end
    end

    delete 'Delete a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, required: true, description: 'User ID'

      response '200', 'user deleted successfully' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        run_test!
      end

      response '404', 'user not found' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:id) { 99999 }
        run_test!
      end

      response '422', 'cannot delete user' do
        schema type: :object,
          properties: {
            error: { type: :string },
            message: { type: :string }
          }

        let(:id) do
          user = User.create(name: 'User with Orders', email: 'orders@example.com', password: 'password', username: 'withorders')
          user.id
        end
        run_test!
      end
    end
  end
end
