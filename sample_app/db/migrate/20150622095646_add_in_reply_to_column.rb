class AddInReplyToColumn < ActiveRecord::Migration
  def change
    add_column :microposts, :in_reply_to, :integer
    add_index :users, :name, :unique :true
  end
end
