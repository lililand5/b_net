class Post < ApplicationRecord
  belongs_to :user

  acts_as_likeable

  has_many :comments, dependent: :destroy
end
