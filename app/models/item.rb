class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :image, presence: true
  validates :name, presence: true
  validates :minimum_bets, presence: true
  validates :online_at, presence: true
  validates :start_at, presence: true
  validates :status, presence: true

  mount_uploader :image, ImageUploader

  enum status: { Inactive: 0, Active: 1 }

  def destroy
    update(deleted_at: Time.current)
  end

  has_many :categories
  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
end
