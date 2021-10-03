class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.references :assignee, foreign_key: { to_table: :users }
      t.string :state, null: false, default: "new"
      t.text :description
      t.text :comment
      t.bigint :managed_by, array: true

      t.timestamps
    end
  end
end
