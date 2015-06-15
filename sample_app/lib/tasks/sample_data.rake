namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # メソッドとして実行
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  # create!は、ユーザが無効な場合にfalseではなく例外を発生させるので、デバッグが容易に
  admin = User.create!(
    name: "Example User",
    email: "example@railstutorial.jp",
    password: "foobar",
    password_confirmation: "foobar",
    admin: true
  )

  # 根岸デバッグ用
  User.create!(
    name: "negi test",
    email: "negi@test.com",
    password: "neginegi",
    password_confirmation: "neginegi",
    admin: true
  )

  98.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.jp"
    password = "password"
    User.create!(
      name: name,
      email: email,
      password: password,
      password_confirmation: password
    )
  end
end

def make_microposts
  users = User.limit(6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
