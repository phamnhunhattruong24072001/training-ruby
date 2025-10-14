class User < ApplicationRecord
  devise :database_authenticatable
  enum role: {
    buyer: 0,
    seller: 1,
  }
end