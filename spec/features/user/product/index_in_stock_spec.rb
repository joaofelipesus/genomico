require 'rails_helper'

RSpec.feature "User::Product::InStocks", type: :feature do
  include UserLogin
  include ValidationChecks

  def generate_stock_entry state
    stock_product = create(:stock_product)
    product = build(:product, stock_product: stock_product, current_state: state)
    stock_entry = create(:stock_entry, product: product)
    stock_entry
  end

  def setup
    Rails.application.load_seed
    create(:user)
    create(:brand)
    generate_stock_entry CurrentState.STOCK
  end

  it "navigate with login" do
    Rails.application.load_seed
    biomol_user_do_login
    click_link id: "stock"
    click_link id: "products-dropdown"
    click_link id: "in-stock-products"
    expect(page).to have_current_path products_path(kind: :stock)
  end

  it "visit without login" do
    visit products_path(kind: :stock)
    wrong_credentials_check
  end

  context "product count validations" do

    before(:each) { setup }

    it "with one product" do
      imunofeno_user_do_login
      visit products_path(kind: :stock)
      check_count css: "product", count: 1
    end

    it "with in stock and in use product", js: false do
      generate_stock_entry CurrentState.IN_USE
      imunofeno_user_do_login
      visit products_path(kind: :stock)
      check_count css: "product", count: 1
    end

    it "with many products 3 in stock and 2 in use" do
      generate_stock_entry CurrentState.STOCK
      generate_stock_entry CurrentState.STOCK
      generate_stock_entry CurrentState.IN_USE
      generate_stock_entry CurrentState.IN_USE
      imunofeno_user_do_login
      visit products_path(kind: :stock)
      check_count css: "product", count: 3
    end

  end

  context "search by name" do

    before :each do
      setup
      @stock_entry = generate_stock_entry CurrentState.STOCK
      generate_stock_entry CurrentState.STOCK
      generate_stock_entry CurrentState.STOCK
      imunofeno_user_do_login
      visit products_path(kind: :stock)
      check_count css: "product", count: 4
    end

    it "with results" do
      fill_in "name", with: @stock_entry.product.stock_product.name
      click_button id: "btn-search-by-name"
      check_count css: "product", count: 1
    end

    it "without results" do
      click_button id: "btn-search-by-name"
      check_count css: "product", count: 4
    end

  end

end
