class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.string :content, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
    # マイクロポストを作成時間の逆順で取り出すため、indexを付与
    # 配列で指定することで、複合キーインデックスを作成
    add_index :microposts, [:user_id, :created_at]
  end
end
