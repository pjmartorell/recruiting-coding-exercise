require 'rails_helper'

RSpec.describe "Products", type: :request do
  before do
    doc = File.read(Rails.root + 'spec/support/eurofxref-hist-90d.xml')
    stub_request(:get, /www.ecb.europa.eu/).to_return(:body => doc)
  end

  describe "GET /products" do
    before do
      3.times do
        Product.create! name: Faker::Commerce.product_name,
          price_in_cents: Faker::Commerce.price * 100,
          description: Faker::Lorem.paragraph
      end
    end

    it "lists all products" do
      get products_path
      expect(response).to have_http_status(200)
      expect(response).to render_template "shared/_footer"
      products = Nokogiri::HTML(response.body).css('.product')
      expect(products.length).to eq(3)
    end
  end

  describe "GET /products" do
    before do
      @product =Product.create! name: Faker::Commerce.product_name,
        price_in_cents: 3456,
        description: Faker::Lorem.paragraph
    end

    it "shows product details" do
      get product_path(@product)
      expect(response).to have_http_status(200)
      expect(response).to render_template "shared/_footer"
      price = Nokogiri::HTML(response.body).css('.product strong')
      expect(price.text).to match(/34.56\sEUR/)
    end
  end
end
