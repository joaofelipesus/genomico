class StockEntry < ApplicationRecord
  belongs_to :reagent
  belongs_to :responsible, class_name: :User
  validates_presence_of :product_amount, :entry_date, :stock_product, :responsible
  belongs_to :stock_product
  paginates_per 10
  has_many :products, dependent: :destroy
  attr_accessor :product
  validates_with StockEntryProductAmountValidator
  validates_with StockEntryProductValidator
  after_create :create_products
  before_validation :convert_has_product_in_object
  after_update :update_stock_products

  def full_update attributes
    product_attributes = attributes[:product]
    stock_entry_attributes = attributes.except :product
    self.update stock_entry_attributes
    self.products.each { |product| product.update(product_attributes) }
  end

  def first_product
    self.products.first
  end

  def can_update_or_remove?
    self.products.where(current_state: CurrentState.IN_USE).empty?
  end

  def self.include_dependencies
    self.includes(:responsible, products: [:current_state, :brand, stock_product: [:field]] )
  end

  private

    def convert_has_product_in_object
      return unless self.product
      self.product = Product.new(self.product) if self.product.is_a? Hash
      self.product.stock_product = self.stock_product
    end

    def create_products
      (0...self.product_amount).each do
        attributes = self.product.attributes
        attributes[:stock_entry] = self
        attributes[:stock_product] = self.stock_product
        Product.create attributes
      end
    end

    def update_stock_products
      self.products.each { |product_to_update| product_to_update.update(stock_product: self.stock_product) }
    end

end
