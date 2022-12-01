class CreateAddressDistricts < ActiveRecord::Migration[7.0]
  def change
    create_table :address_districts do |t|
      t.timestamps
    end
  end
end
