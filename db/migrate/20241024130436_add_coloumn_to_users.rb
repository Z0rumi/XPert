class AddColoumnToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :initiated, :boolean, default: false
  end
end
