require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  path '/api/v1/auth/login' do
    post 'Login user' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@gmail.com' },
          password: { type: :string, example: '11111111' }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'login successful' do
        schema type: :object,
          properties: {
            message: { type: :string },
            token: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                name: { type: :string }
              }
            }
          }

        let(:user) { { email: 'test@example.com', password: 'password' } }
        run_test!
      end

      response '401', 'invalid credentials' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:user) { { email: 'wrong@example.com', password: 'wrong' } }
        run_test!
      end
    end
  end

  path '/api/v1/auth/register' do
    post 'Register new user' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: '' },
          password: { type: :string, example: '' },
          password_confirmation: { type: :string, example: '' },
          name: { type: :string, example: '' },
          username: { type: :string, example: '' }
        },
        required: [ 'email', 'password', 'password_confirmation', 'username' ]
      }

      response '201', 'user created' do
        schema type: :object,
          properties: {
            message: { type: :string },
            user: {
              type: :object,
              properties: {
                id: { type: :integer },
                email: { type: :string },
                name: { type: :string },
                username: { type: :string }
              }
            }
          }

        let(:user) { { user: { email: 'new@example.com', password: 'password', password_confirmation: 'password', name: 'New User' } } }
        run_test!
      end

      response '422', 'invalid request' do
        schema type: :object,
          properties: {
            errors: { type: :array, items: { type: :string } }
          }

        let(:user) { { user: { email: 'invalid' } } }
        run_test!
      end
    end
  end

  path '/api/v1/auth/profile' do
    get 'Get current user profile' do
      tags 'Auth'
      produces 'application/json'

      response '200', 'user profile retrieved successfully' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                email: { type: :string, example: 'user@example.com' },
                name: { type: :string, example: 'John Doe' }
              }
            }
          }

        let!(:user) { User.create!(email: 'profile@example.com', password: 'password', name: 'Profile User') }

        let(:authorization) { "Bearer #{JsonWebToken.encode(user_id: user.id)}" }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['email']).to eq('profile@example.com')
        end
      end

      response '401', 'unauthorized' do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'Invalid token' }
          }

        run_test!
      end
    end
  end

  path '/api/v1/auth/forgot-password' do
    post 'Request password reset' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :email, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' }
        },
        required: [ 'email' ]
      }

      response '200', 'reset email sent' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let(:email) { { email: 'user@example.com' } }
        run_test!
      end
    end
  end

  path '/api/v1/auth/reset-password' do
    post 'Reset password' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :reset_data, in: :body, schema: {
        type: :object,
        properties: {
          token: { type: :string, example: 'reset_token' },
          password: { type: :string, example: 'newpassword' },
          password_confirmation: { type: :string, example: 'newpassword' }
        },
        required: [ 'token', 'password', 'password_confirmation' ]
      }

      response '200', 'password reset successful' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let(:reset_data) { { token: 'valid_token', password: 'newpassword', password_confirmation: 'newpassword' } }
        run_test!
      end

      response '422', 'invalid reset token' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:reset_data) { { token: 'invalid_token', password: 'newpassword', password_confirmation: 'newpassword' } }
        run_test!
      end
    end
  end

  path "/api/v1/auth/change-password" do
    post "change password" do
      tags "Auth"
      consumes 'application/json'
      produces 'application/json'

      parameter name: :change_password_data, in: :body, schema: {
        type: :object,
        properties: {
          current_password: { type: :string, example: '' },
          new_password: { type: :string, example: '' },
          password_confirmation: { type: :string, example: '' }
        },
        required: [ 'current_password', 'new_password', 'password_confirmation' ]
      }

      response '200', 'Change password successful' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        let(:change_password_data) { { current_password: 'oldpassword', new_password: 'newpassword', password_confirmation: 'password_confirmation' } }
        run_test!
      end

      response '422', 'Change password unsuccessful' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:change_password_data) { { current_password: 'oldpassword', new_password: 'newpassword', password_confirmation: 'password_confirmation' } }
        run_test!
      end
    end
  end
end
