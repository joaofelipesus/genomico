class MigrateReagentDataToStockProduct < ActiveRecord::Migration[5.2]
  def change
    Reagent.all.each do |reagent|
      p reagent
      stock_item = StockProduct.create({
        name: reagent.name,
        usage_per_test: reagent.usage_per_test,
        total_aviable: reagent.total_aviable,
        first_warn_at: reagent.first_warn_at,
        danger_warn_at: reagent.danger_warn_at,
        mv_code: reagent.mv_code,
        unit_of_measurement: reagent.unit_of_measurement,
        field: reagent.field,
      })
      if reagent.field.nil?
        stock_item.is_shared = true
      else
        stock_item.is_shared = false
      end
      p stock_item
    end
  end
end
