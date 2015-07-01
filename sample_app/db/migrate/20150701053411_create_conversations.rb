class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :user_id, null: false
      t.integer :partner_id, null: false

      t.timestamps null: false
    end
    add_index :conversations, [:user_id, :partner_id], unique: true
  end
end
