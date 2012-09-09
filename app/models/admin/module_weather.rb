class Admin::ModuleWeather < ActiveRecord::Base

  # validates_uniqueness_of :date, :scope => [:city, :country]

  def self.get_args
    args = Hash.new
    args[:city] = "Zagreb"
    args[:country] = "Croatia"
    args[:num_of_days] = 1
    args[:key] = "1a75ab32de233416120209"

    args
  end

  def self.fetch(args)
    require 'net/http'

    location = args[:city] << "," << args[:country]


    url = URI.parse("http://free.worldweatheronline.com/feed/weather.ashx?q=" << location << "&format=xml&num_of_days=" << args[:num_of_days].to_s << "&key=" << args[:key])
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }

    xml_content = res.body
    #data = XmlSimple.xml_in(xml_content,{:ForceArray => false})

    report = Hash.from_xml(xml_content).with_indifferent_access

    data = report[:data]

    weathers = data[:weather]
    query = data[:request][:query]
    query = query.split(",")

    city = query[0]
    country = query[1]

    attributes = Admin::ModuleWeather.column_names
    records = []

    unless weathers.respond_to?(:has_key?)
      weathers.each do |weather|
        record = Admin::ModuleWeather.new()

        record.city=city
        record.country=country

        weather.each_pair do |attr, value|
          if attributes.include?(attr)
            record[attr] = value
          end
        end

        records << record
      end
    else
      weather = weathers
      record = Admin::ModuleWeather.new()

      record.city=city
      record.country=country

      weather.each_pair do |attr, value|
        if attributes.include?(attr)
          record[attr] = value
        end
      end

      records << record
    end

    return_obj = Hash.new
    return_obj[:success] = true
    return_obj[:details] = ""
    return_obj[:records] = records

    return_obj
  end
end
