require "rails_helper"

feature "User switches currency", :js => true do
  before do
    doc = File.read(Rails.root + 'spec/support/eurofxref-hist-90d.xml')
    stub_request(:get, /www.ecb.europa.eu/).to_return(:body => doc)
  end

  scenario "sees the product in the selected currency" do
    @product = Product.create! name: Faker::Commerce.product_name,
      price_in_cents: 3456,
      description: Faker::Lorem.paragraph

    visit product_path(@product)
    page.select 'USD', :from => 'currency'

    expect(page.find('.price')).to have_text("36.88")
  end

  scenario "sees the list of products in the selected currency" do
    3.times do
      Product.create! name: Faker::Commerce.product_name,
        price_in_cents: 3456,
        description: Faker::Lorem.paragraph
    end

    visit products_path
    page.select 'USD', :from => 'currency'

    expect(page.first('.price')).to have_text("36.88")
  end

   scenario "and after a page reload sees product price in the current currency" do
    3.times do
      Product.create! name: Faker::Commerce.product_name,
        price_in_cents: 3456,
        description: Faker::Lorem.paragraph
    end

    visit products_path
    page.select 'USD', :from => 'currency'
    visit product_path(Product.first)

    expect(page.find('.price')).to have_text("36.88")
  end
end
