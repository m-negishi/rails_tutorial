class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id, null: false
      t.string :content, null: false
      t.integer :in_reply_to, null: false

      t.timestamps null: false
    end

    add_index :messages, :user_id
    add_index :messages, :in_reply_to
  end
end
