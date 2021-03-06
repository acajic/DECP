# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120903000321) do

  create_table "admin_decp_modules", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active",            :default => false
    t.string   "migration_version"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "admin_module_rates", :force => true do |t|
    t.integer  "timestamp",                                 :null => false
    t.decimal  "AED",        :precision => 15, :scale => 6
    t.decimal  "AFN",        :precision => 15, :scale => 6
    t.decimal  "ALL",        :precision => 15, :scale => 6
    t.decimal  "AMD",        :precision => 15, :scale => 6
    t.decimal  "ANG",        :precision => 15, :scale => 6
    t.decimal  "AOA",        :precision => 15, :scale => 6
    t.decimal  "ARS",        :precision => 15, :scale => 6
    t.decimal  "AUD",        :precision => 15, :scale => 6
    t.decimal  "AWG",        :precision => 15, :scale => 6
    t.decimal  "AZN",        :precision => 15, :scale => 6
    t.decimal  "BAM",        :precision => 15, :scale => 6
    t.decimal  "BBD",        :precision => 15, :scale => 6
    t.decimal  "BDT",        :precision => 15, :scale => 6
    t.decimal  "BGN",        :precision => 15, :scale => 6
    t.decimal  "BHD",        :precision => 15, :scale => 6
    t.decimal  "BIF",        :precision => 15, :scale => 6
    t.decimal  "BMD",        :precision => 15, :scale => 6
    t.decimal  "BND",        :precision => 15, :scale => 6
    t.decimal  "BOB",        :precision => 15, :scale => 6
    t.decimal  "BRL",        :precision => 15, :scale => 6
    t.decimal  "BSD",        :precision => 15, :scale => 6
    t.decimal  "BTN",        :precision => 15, :scale => 6
    t.decimal  "BWP",        :precision => 15, :scale => 6
    t.decimal  "BYR",        :precision => 15, :scale => 6
    t.decimal  "BZD",        :precision => 15, :scale => 6
    t.decimal  "CAD",        :precision => 15, :scale => 6
    t.decimal  "CDF",        :precision => 15, :scale => 6
    t.decimal  "CHF",        :precision => 15, :scale => 6
    t.decimal  "CLF",        :precision => 15, :scale => 6
    t.decimal  "CLP",        :precision => 15, :scale => 6
    t.decimal  "CNY",        :precision => 15, :scale => 6
    t.decimal  "COP",        :precision => 15, :scale => 6
    t.decimal  "CRC",        :precision => 15, :scale => 6
    t.decimal  "CUP",        :precision => 15, :scale => 6
    t.decimal  "CVE",        :precision => 15, :scale => 6
    t.decimal  "CZK",        :precision => 15, :scale => 6
    t.decimal  "DJF",        :precision => 15, :scale => 6
    t.decimal  "DKK",        :precision => 15, :scale => 6
    t.decimal  "DOP",        :precision => 15, :scale => 6
    t.decimal  "DZD",        :precision => 15, :scale => 6
    t.decimal  "EGP",        :precision => 15, :scale => 6
    t.decimal  "ETB",        :precision => 15, :scale => 6
    t.decimal  "EUR",        :precision => 15, :scale => 6
    t.decimal  "FJD",        :precision => 15, :scale => 6
    t.decimal  "FKP",        :precision => 15, :scale => 6
    t.decimal  "GBP",        :precision => 15, :scale => 6
    t.decimal  "GEL",        :precision => 15, :scale => 6
    t.decimal  "GHS",        :precision => 15, :scale => 6
    t.decimal  "GIP",        :precision => 15, :scale => 6
    t.decimal  "GMD",        :precision => 15, :scale => 6
    t.decimal  "GNF",        :precision => 15, :scale => 6
    t.decimal  "GTQ",        :precision => 15, :scale => 6
    t.decimal  "GYD",        :precision => 15, :scale => 6
    t.decimal  "HKD",        :precision => 15, :scale => 6
    t.decimal  "HNL",        :precision => 15, :scale => 6
    t.decimal  "HRK",        :precision => 15, :scale => 6
    t.decimal  "HTG",        :precision => 15, :scale => 6
    t.decimal  "HUF",        :precision => 15, :scale => 6
    t.decimal  "IDR",        :precision => 15, :scale => 6
    t.decimal  "ILS",        :precision => 15, :scale => 6
    t.decimal  "INR",        :precision => 15, :scale => 6
    t.decimal  "IQD",        :precision => 15, :scale => 6
    t.decimal  "IRR",        :precision => 15, :scale => 6
    t.decimal  "ISK",        :precision => 15, :scale => 6
    t.decimal  "JMD",        :precision => 15, :scale => 6
    t.decimal  "JOD",        :precision => 15, :scale => 6
    t.decimal  "JPY",        :precision => 15, :scale => 6
    t.decimal  "KES",        :precision => 15, :scale => 6
    t.decimal  "KGS",        :precision => 15, :scale => 6
    t.decimal  "KHR",        :precision => 15, :scale => 6
    t.decimal  "KMF",        :precision => 15, :scale => 6
    t.decimal  "KPW",        :precision => 15, :scale => 6
    t.decimal  "KRW",        :precision => 15, :scale => 6
    t.decimal  "KWD",        :precision => 15, :scale => 6
    t.decimal  "KZT",        :precision => 15, :scale => 6
    t.decimal  "LAK",        :precision => 15, :scale => 6
    t.decimal  "LBP",        :precision => 15, :scale => 6
    t.decimal  "LKR",        :precision => 15, :scale => 6
    t.decimal  "LRD",        :precision => 15, :scale => 6
    t.decimal  "LSL",        :precision => 15, :scale => 6
    t.decimal  "LTL",        :precision => 15, :scale => 6
    t.decimal  "LVL",        :precision => 15, :scale => 6
    t.decimal  "LYD",        :precision => 15, :scale => 6
    t.decimal  "MAD",        :precision => 15, :scale => 6
    t.decimal  "MDL",        :precision => 15, :scale => 6
    t.decimal  "MGA",        :precision => 15, :scale => 6
    t.decimal  "MKD",        :precision => 15, :scale => 6
    t.decimal  "MMK",        :precision => 15, :scale => 6
    t.decimal  "MNT",        :precision => 15, :scale => 6
    t.decimal  "MOP",        :precision => 15, :scale => 6
    t.decimal  "MRO",        :precision => 15, :scale => 6
    t.decimal  "MUR",        :precision => 15, :scale => 6
    t.decimal  "MVR",        :precision => 15, :scale => 6
    t.decimal  "MWK",        :precision => 15, :scale => 6
    t.decimal  "MXN",        :precision => 15, :scale => 6
    t.decimal  "MYR",        :precision => 15, :scale => 6
    t.decimal  "MZN",        :precision => 15, :scale => 6
    t.decimal  "NAD",        :precision => 15, :scale => 6
    t.decimal  "NGN",        :precision => 15, :scale => 6
    t.decimal  "NIO",        :precision => 15, :scale => 6
    t.decimal  "NOK",        :precision => 15, :scale => 6
    t.decimal  "NPR",        :precision => 15, :scale => 6
    t.decimal  "NZD",        :precision => 15, :scale => 6
    t.decimal  "OMR",        :precision => 15, :scale => 6
    t.decimal  "PAB",        :precision => 15, :scale => 6
    t.decimal  "PEN",        :precision => 15, :scale => 6
    t.decimal  "PGK",        :precision => 15, :scale => 6
    t.decimal  "PHP",        :precision => 15, :scale => 6
    t.decimal  "PKR",        :precision => 15, :scale => 6
    t.decimal  "PLN",        :precision => 15, :scale => 6
    t.decimal  "PYG",        :precision => 15, :scale => 6
    t.decimal  "QAR",        :precision => 15, :scale => 6
    t.decimal  "RON",        :precision => 15, :scale => 6
    t.decimal  "RSD",        :precision => 15, :scale => 6
    t.decimal  "RUB",        :precision => 15, :scale => 6
    t.decimal  "RWF",        :precision => 15, :scale => 6
    t.decimal  "SAR",        :precision => 15, :scale => 6
    t.decimal  "SBD",        :precision => 15, :scale => 6
    t.decimal  "SCR",        :precision => 15, :scale => 6
    t.decimal  "SDG",        :precision => 15, :scale => 6
    t.decimal  "SEK",        :precision => 15, :scale => 6
    t.decimal  "SGD",        :precision => 15, :scale => 6
    t.decimal  "SHP",        :precision => 15, :scale => 6
    t.decimal  "SLL",        :precision => 15, :scale => 6
    t.decimal  "SOS",        :precision => 15, :scale => 6
    t.decimal  "SRD",        :precision => 15, :scale => 6
    t.decimal  "STD",        :precision => 15, :scale => 6
    t.decimal  "SVC",        :precision => 15, :scale => 6
    t.decimal  "SYP",        :precision => 15, :scale => 6
    t.decimal  "SZL",        :precision => 15, :scale => 6
    t.decimal  "THB",        :precision => 15, :scale => 6
    t.decimal  "TJS",        :precision => 15, :scale => 6
    t.decimal  "TMT",        :precision => 15, :scale => 6
    t.decimal  "TND",        :precision => 15, :scale => 6
    t.decimal  "TOP",        :precision => 15, :scale => 6
    t.decimal  "TRY",        :precision => 15, :scale => 6
    t.decimal  "TTD",        :precision => 15, :scale => 6
    t.decimal  "TWD",        :precision => 15, :scale => 6
    t.decimal  "TZS",        :precision => 15, :scale => 6
    t.decimal  "UAH",        :precision => 15, :scale => 6
    t.decimal  "UGX",        :precision => 15, :scale => 6
    t.decimal  "USD",        :precision => 15, :scale => 6
    t.decimal  "UYU",        :precision => 15, :scale => 6
    t.decimal  "UZS",        :precision => 15, :scale => 6
    t.decimal  "VEF",        :precision => 15, :scale => 6
    t.decimal  "VND",        :precision => 15, :scale => 6
    t.decimal  "VUV",        :precision => 15, :scale => 6
    t.decimal  "WST",        :precision => 15, :scale => 6
    t.decimal  "XAF",        :precision => 15, :scale => 6
    t.decimal  "XCD",        :precision => 15, :scale => 6
    t.decimal  "XDR",        :precision => 15, :scale => 6
    t.decimal  "XOF",        :precision => 15, :scale => 6
    t.decimal  "XPF",        :precision => 15, :scale => 6
    t.decimal  "YER",        :precision => 15, :scale => 6
    t.decimal  "ZAR",        :precision => 15, :scale => 6
    t.decimal  "ZMK",        :precision => 15, :scale => 6
    t.decimal  "ZWL",        :precision => 15, :scale => 6
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "admin_module_rates", ["timestamp"], :name => "index_admin_module_rates_on_timestamp", :unique => true

  create_table "admin_module_weathers", :force => true do |t|
    t.string   "city"
    t.string   "country"
    t.date     "date"
    t.decimal  "tempMaxC",       :precision => 10, :scale => 0
    t.decimal  "tempMinC",       :precision => 10, :scale => 0
    t.decimal  "windspeedKmph",  :precision => 10, :scale => 0
    t.string   "winddirection"
    t.string   "weatherIconUrl"
    t.string   "weatherDesc"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "currencies", :force => true do |t|
    t.string   "abbr"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "logs", :force => true do |t|
    t.integer  "admin_decp_module_id"
    t.boolean  "success"
    t.text     "details"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

end
