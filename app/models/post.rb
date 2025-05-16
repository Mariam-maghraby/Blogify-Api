class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  # Allow nested tag attributes if you want to create tags by name
  accepts_nested_attributes_for :tags, allow_destroy: true

  validates :tags, presence: true
end
