# Rspec実行時に使うテストデータ
# ActiveRecordを使ってデータを登録することもできるが、
# 複数のテストケースで同じデータを使いたい場合に、ここで定義しておくと、Rspecから呼び出せる
FactoryGirl.define do
  factory :user do
    # 名前とメールアドレスを一意にするためにsequenceメソッドを使う
    # name 'Michael Hartl'
    # email 'michael@example.com'
    sequence(:name) { |n| "Person_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password 'foobar'
    password_confirmation 'foobar'

    # FactoryGirl.create(:admin)で呼び出せる
    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    # ここにuserを含めるだけで、関連付けができる
    user
  end

  factory :message do
    content "Lorem ipsum"
    user
  end
end
