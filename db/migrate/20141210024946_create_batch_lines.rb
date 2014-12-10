class CreateBatchLines < ActiveRecord::Migration
  def change
    create_table :batch_lines do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.references :person, index: true
      t.string :tender, limit: 7
      t.references :fund, index: true

      t.timestamps
    end
  end
end
