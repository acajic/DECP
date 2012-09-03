class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.references :admin_decp_module
      t.boolean :success
      t.text :details

      t.timestamps
    end
  end
end
