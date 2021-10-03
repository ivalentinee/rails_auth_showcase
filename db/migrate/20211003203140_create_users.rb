class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :role
      t.string :phone_number
      t.bigint :managed_by, array: true

      t.timestamps
    end
  end
end
