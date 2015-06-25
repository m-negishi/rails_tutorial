namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # メソッドとして実行
    make_users
    make_microposts
    make_replies
    make_relationships
    make_messages
  end
end

def make_users
  # create!は、ユーザが無効な場合にfalseではなく例外を発生させるので、デバッグが容易に
  admin = User.create!(
    name: "Example_User",
    email: "example@railstutorial.jp",
    password: "foobar",
    password_confirmation: "foobar",
    admin: true
  )

  # 根岸デバッグ用
  User.create!(
    name: "negi_test",
    email: "negi@test.com",
    password: "neginegi",
    password_confirmation: "neginegi",
    admin: true
  )

  98.times do |n|
    name = Faker::Name.name.gsub!(/\s/, '_')
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

def make_replies
  users = User.limit(3)
  reply_users = User.limit(3)
  users.each do |user|
    reply_users.each do |reply_user|
      5.times do
        content = "@#{reply_user.name} #{Faker::Lorem.sentence(5)}"
        user.microposts.create!(content: content)
      end
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[1..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_messages
  users = User.limit(6)
  reply_users = User.limit(6)
  users.each do |user|
    reply_users.each do |reply_user|
      10.times do
        content = "d @#{reply_user.name} #{Faker::Lorem.sentence(5)}"
        user.messages.create!(content: content, in_reply_to: user.id)
      end
    end
  end
end
