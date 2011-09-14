class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :identifier
      t.references :account

      t.timestamps
    end
    add_index :groups, :account_id
  end
end
