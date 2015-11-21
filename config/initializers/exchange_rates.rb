unless Rails.env.test?
  ExchangeRatesFeeder.ttl_in_seconds = 6.hours
  ExchangeRatesFeeder.get_rates
end
