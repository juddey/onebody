class AddLastloginToPeople < ActiveRecord::Migration
  def change
    add_column :people, :last_login, :text
    add_column :people, :last_updated, :datetime
  end
end
