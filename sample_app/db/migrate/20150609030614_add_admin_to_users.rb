class AddAdminToUsers < ActiveRecord::Migration
  def change
    # デフォルトで管理者になれないように、明示的にdefaultを定義
    add_column :users, :admin, :boolean, default: false
  end
end
