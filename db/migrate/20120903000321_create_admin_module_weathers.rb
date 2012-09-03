class CreateAdminModuleWeathers < ActiveRecord::Migration
  def change
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
  end
end
