class Admin::ModuleRate < ActiveRecord::Base
  validates_uniqueness_of :timestamp

  def self.save_multi(rates)
    ActiveRecord::Base.transaction do
      rates.each do |rate|
        rate.save
      end
    end
  end


  def self.get_args
    params = Hash.new
    params[:from_date] = "2012-08-12"
    params[:to_date] = "2012-08-14"

    params
  end

  def self.fetch(args)
    require 'date'
    require 'net/http'

    dates_str = [Date.today.to_s]


    if args.has_key? :date
      dates_str = [args[:date]]
    elsif args.has_key? :from_date and args.has_key? :to_date
      date_from_str = args[:from_date]
      date_from = Date.strptime(date_from_str, "%Y-%m-%d")
      date_to_str = args[:to_date]
      date_to = Date.strptime(date_to_str, "%Y-%m-%d")
      dates_str = []
      while date_from <= date_to
        date_str = date_from.to_s
        dates_str << date_str
        date_from = date_from.tomorrow
      end

    end

    rates = []

    dates_str.each do |date_str|

      url = URI.parse('http://openexchangerates.org/api/historical/' + date_str + '.json')
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port) { |http|
        http.request(req)
      }

      json_content = res.body

      report = ActiveSupport::JSON.decode json_content

      init_hash = report["rates"]

      init_hash["timestamp"] = report["timestamp"];

      rates << Admin::ModuleRate.new(init_hash)
    end

    return_obj = Hash.new
    return_obj[:success] = true
    return_obj[:details] = ""
    return_obj[:records] = rates

    return_obj
  end
end
