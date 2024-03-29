require 'rails_helper'

RSpec.feature "User::StockEntry::Edits", type: :feature, js: true do
  include UserLogin
  include ValidationChecks

  before :each do
    Rails.application.load_seed
    create(:user, kind: :user)
    create(:brand)
    create(:brand)
    stock_product = create(:stock_product, field: Field.IMUNOFENO)
    product = build(:product)
    @stock_entry = create(:stock_entry, product: product, stock_product: stock_product)
    product = build(:product)
    stock_entry = create(:stock_entry, product: product, stock_product: stock_product)
    product = build(:product)
    stock_entry = create(:stock_entry, product: product, stock_product: stock_product)
    biomol_stock_product = create(:stock_product, field: Field.BIOMOL)
    product = build(:product, stock_product: biomol_stock_product)
    stock_entry = create(:stock_entry, product: product, stock_product: biomol_stock_product)
    imunofeno_user_do_login
    click_link id: "stock"
    click_link id: "stock-entries-dropdown"
    click_link id: "stock-entries"
    click_link class: "edit-stock-entry", match: :first
  end

  it "navigate to", js: false do
    expect(page).to have_current_path edit_stock_entry_path(StockEntry.all.order(entry_date: :desc).first)
  end

  context "correct changes" do

    after(:each) { success_check stock_entries_path, :edit_stock_entry_success }

    it "change responsible" do
      select(User.where(kind: :user).sample.login, from: "stock_entry[responsible_id]").select_option
    end

    it "change entry date" do
      fill_in "stock_entry[entry_date]", with: 5.days.ago
      click_button id: "btn-save"
    end

    it "change product" do
      select(Field.BIOMOL.name, from: "fields-select").select_option
      select(StockProduct.where(field: Field.BIOMOL).last.name, from: "stock_entry[stock_product_id]").select_option
    end

    it "change brand" do
      select(Brand.all.sample.name, from: "stock_entry[product][brand_id]").select_option
    end

    it "change lot" do
      fill_in "stock_entry[product][lot]", with: "some123new123lot"
    end

    it "without shelf_life" do
      choose "stock_entry[product][has_shelf_life]", option: "false"
    end

    it "change amount" do
      fill_in "stock_entry[product][amount]", with: "3"
    end

    it "change location" do
      fill_in "stock_entry[product][location]", with: "Some uda location"
    end

  end

  it "without lot" do
    fill_in "stock_entry[product][lot]", with: ""
    without_value "Lote"
  end

  it "without amount" do
    fill_in "stock_entry[product][amount]", with: ""
    without_value "Quantidade"
  end

  it "without location" do
    fill_in "stock_entry[product][location]", with: ""
    without_value "Localização"
  end

end
