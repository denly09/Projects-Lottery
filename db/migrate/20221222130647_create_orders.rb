class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user
      t.references :offer
      t.string :serial_number
      t.string :state
      t.decimal :amount, precision: 12, scale: 2, default: 0
      t.integer :coins, default: 0
      t.string :remarks
      t.integer :genre
      t.timestamps
    end
  end
end
