class Currency < ActiveRecord::Base

  has_many :module_exchange_rates

  def self.refresh(currency_array)
    require 'iconv' # ovaj iconv je zato sto se pojavljuju neki cudni znakovi u nazivima valuta pa se aplikacija krsi

    ActiveRecord::Base.transaction do
      currency_array.each_pair { |abbr, name|
        curr = Currency.find_by_abbr(abbr)
        if curr.nil?
          Currency.create(:abbr => abbr, :name => Iconv.iconv('UTF-8', 'MS-ANSI', name).to_s)
        else
          curr.name = Iconv.iconv('UTF-8', 'MS-ANSI', name).to_s
          curr.save
        end
      }
    end
  end

end
