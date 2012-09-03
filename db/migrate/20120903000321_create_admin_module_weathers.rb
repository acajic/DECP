class CreateAdminModuleWeathers < ActiveRecord::Migration
  def up
    create_table :admin_module_weathers do |t|
      t.string :city
      t.string :country
      t.date :date
      t.decimal :tempMaxC
      t.decimal :tempMinC
      t.decimal :windspeedKmph
      t.string :winddirection
      t.string :weatherIconUrl
      t.string :weatherDesc

      t.timestamps
    end
    Admin::DecpModule.create(:name => "weathers", :description => "Weather forecasts", :migration_version=>"20120903000321")
  end

  def down
    drop_table :admin_module_weathers
  end
end
