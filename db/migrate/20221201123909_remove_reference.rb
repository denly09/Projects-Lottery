class RemoveReference < ActiveRecord::Migration[7.0]
  def change
    remove_reference :address_city_municipalities, :district
  end
end
