class AddParentToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :parent
  end
end
