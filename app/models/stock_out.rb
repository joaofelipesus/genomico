class StockOut < ApplicationRecord
  belongs_to :stock_product
  belongs_to :product
  belongs_to :responsible, class_name: :User
  before_validation :set_stock_product
  validates :product, :date, :responsible, :stock_product, presence: true
  paginates_per 14
  before_save :change_product_current_status

  private

    def change_product_current_status
      self.product.update(current_state: CurrentState.OUT) if self.product.current_state == CurrentState.IN_USE
    end

    def set_stock_product
      return if self.product.nil?
      self.stock_product = self.product.stock_product unless self.stock_product
    end

end
