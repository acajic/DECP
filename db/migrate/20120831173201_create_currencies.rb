require 'iconv'

class CreateCurrencies < ActiveRecord::Migration
  def up
    create_table :currencies do |t|
      t.string "abbr"
      t.string "name"
      t.timestamps
    end
  end

  def down
    drop_table :currencies
  end
end
