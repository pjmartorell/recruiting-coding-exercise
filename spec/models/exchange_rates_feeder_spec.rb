require 'rails_helper'
require "exchange_rates_feeder"

describe ExchangeRatesFeeder do
  before do
    doc = File.read(Rails.root + 'spec/support/eurofxref-hist-90d.xml')
    stub_request(:get, /www.ecb.europa.eu/).to_return(:body => doc)
  end

  it "parses correct exchange rates" do
    expect(subject.get_rates[:USD].to_s).to eq("1.067")
  end
end
