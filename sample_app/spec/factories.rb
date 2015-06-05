# Rspec実行時に使うテストデータ
# ActiveRecordを使ってデータを登録することもできるが、
# 複数のテストケースで同じデータを使いたい場合に、ここで定義しておくと、Rspecから呼び出せる
FactoryGirl.define do
  factory :user do
    name 'Michael Hartl'
    email 'michael@example.com'
    password 'foobar'
    password_confirmation 'foobar'
  end
end
