require 'net/http'

class Modules::ModuleRatesController < ApplicationController

  def test
    url = URI.parse('http://openexchangerates.org/api/currencies.json')
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }

    json_content = res.body
    @currencies = ActiveSupport::JSON.decode json_content


  end

  def refresh_currencies
    url = URI.parse('http://openexchangerates.org/api/currencies.json')
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }

    json_manager = ActiveSupport::JSON
    json_content = res.body
    currency_array = json_manager.decode json_content
    Currency.refresh(currency_array)
  end

  def fetch
    require 'date'

    dates_str = [Date.today.to_s]


    if params.has_key? :date
      dates_str = [params[:date]]
    elsif params.has_key? :from_date and params.has_key? :to_date
      date_from_str = params[:from_date]
      date_from = Date.strptime(date_from_str, "%Y-%m-%d")
      date_to_str = params[:to_date]
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

    Admin::ModuleRate.save_multi(rates)
  end

end