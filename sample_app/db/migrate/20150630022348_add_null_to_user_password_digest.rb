class AddNullToUserPasswordDigest < ActiveRecord::Migration
  def change
    change_column :users, :remember_token, :string, null: false
  end
end
