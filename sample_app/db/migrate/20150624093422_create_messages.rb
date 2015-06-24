class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id
      t.string :content
      t.integer :in_reply_to

      t.timestamps null: false
    end

    add_index :messages, :user_id
    add_index :messages, :in_reply_to
  end
end
