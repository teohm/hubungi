class AddIsPublicToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :is_public, :boolean, :default => true
  end
end
