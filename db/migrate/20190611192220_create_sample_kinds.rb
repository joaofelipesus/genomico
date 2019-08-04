class CreateSampleKinds < ActiveRecord::Migration[5.2]
  def change
    create_table :sample_kinds do |t|
      t.string :name
      t.string :acronym
      t.integer :refference_index

      t.timestamps null: false
    end
  end
end
