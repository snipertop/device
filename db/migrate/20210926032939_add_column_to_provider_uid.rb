class AddColumnToProviderUid < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :provider ,:string
    add_column :users, :uid ,:integer
  end
end
