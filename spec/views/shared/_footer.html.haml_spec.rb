require 'rails_helper'

describe 'shared/_footer' do
  before do
    doc = File.read(Rails.root + 'spec/support/eurofxref-hist-90d.xml')
    stub_request(:get, /www.ecb.europa.eu/).to_return(:body => doc)
  end

  it "should display copyright and select box" do
    assign(:exchange_rates, {:EUR => "1.0"})
    render
    copyright = Nokogiri::HTML(rendered).css('#copyright')

    expect(copyright).to have_content(Time.now.year)
    expect(rendered).to have_selector('#currency')
  end
end
