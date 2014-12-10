class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.integer :site_id
      t.string :name, limit: 100
      t.string :display_name, limit: 10
      t.boolean :active, default: true
      t.boolean :online, default: false
      t.boolean :default_fund, default: false
      t.date :active_from
      t.date :active_to
      t.string :bank_account
      t.string :gl_account
      t.boolean :taxed

      t.timestamps
    end
  end
end
