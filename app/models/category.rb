class Category < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :name, presence: true

  has_many :item_category_ships
  has_many :item, through: :item_category_ships
end
