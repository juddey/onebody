class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.integer :site_id
      t.string :name, limit: 30
      t.date :opening_date
      t.date :deposit_date
      t.decimal :amount, precision: 8, scale: 2
      t.string :status, limit: 10
      t.string :batch_type, limit: 10
      t.text :comments

      t.timestamps
    end
    add_index :batches, :opening_date
  end
end
