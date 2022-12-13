class Address < ApplicationRecord
  ADDRESS_LIMIT = 5
  validates :name, :genre, :street_address, presence: true
  validates :phone_number, presence: true, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }, length: { maximum: 13 }
  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city_municipality, class_name: 'Address::CityMunicipality', foreign_key: 'address_city_municipality_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'
  enum genre: { home: 0, office: 1 }
  before_create :default_address_empty
  after_save :default_address

  def limit_count
    return unless self.user
    if self.user.addresses.reload.count >= ADDRESS_LIMIT
      errors.add(:base, "You reached the limit")
    end
  end

  def default_address_empty
    if user.addresses.empty?
      self.is_default = true
    else
      self.is_default = false
    end
  end

  def default_address
    if is_default
      user.address.where('id != ?', id).update_all(is_default: false)
    end
  end
end
