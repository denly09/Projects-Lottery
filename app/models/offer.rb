class Offer < ApplicationRecord
  validates :name, :image, :coin, :genre, :amount, :status, presence: true
  enum status: { inactive: 0, active: 1 }
  enum genre: { one_time: 0, monthly: 1, weekly: 2, daily: 3, regular: 4 }

  mount_uploader :image, ImageUploader

  has_many  :orders
end
