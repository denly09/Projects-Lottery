class Address < ApplicationRecord
  Address_Limit = 5
  validates :name, :genre, :street_address, presence: true
  validates :phone, presence: true, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }, length: { maximum: 13 }
  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city_municipality, class_name: 'Address::CityMunicipality', foreign_key: 'address_city_municipality_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'
  enum genre: { home: 0, office: 1 }

  def limit_address
    return unless self.user
    if self.user.addresses.reload.count >= Address_Limit
      errors.add(:base, "You reached the limit")
    end
  end
end
