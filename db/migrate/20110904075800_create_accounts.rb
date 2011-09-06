class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :provider
      t.string :identifier
      t.string :display_name
      t.string :auth_type
      t.string :auth_token1
      t.string :auth_token2
      t.references :profile

      t.timestamps
    end
    add_index :accounts, :profile_id
  end
end
