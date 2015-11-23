require "nokogiri"
require "open-uri"

module ExchangeRatesFeeder
  class << self

    ECB_URL = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"

    attr_accessor :ttl_in_seconds

    def get_rates
      Rails.cache.fetch("#{cache_key}", expires_in: ttl_in_seconds) do
        begin
          xml = Nokogiri::XML(open(ECB_URL))
          rates = Hash.new
          rates[:EUR] = BigDecimal(1)
          xml.css("Cube > Cube:nth-of-type(1) > Cube").each do |e|
            rates[e[:currency].to_sym] = BigDecimal(e[:rate])
          end
        rescue
          puts "Couldn't read exchange rates from \"#{ ECB_URL }\""
        end
        rates
      end
    end

    def cache_key
      "exchange_rates"
    end
  end
end
