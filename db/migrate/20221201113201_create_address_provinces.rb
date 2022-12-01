class CreateAddressProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :address_provinces do |t|
      t.string  :name
      t.string  :code
      t.references :region
      t.timestamps
    end
  end
end
