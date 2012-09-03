class CreateAdminDecpModules < ActiveRecord::Migration
  def up
    create_table :admin_decp_modules do |t|
      t.string "name"
      t.text "description"
      t.boolean "active", :default => false
      t.string "migration_version"
      t.timestamps
    end

  end


  def down
    drop_table :admin_decp_modules
  end
end
