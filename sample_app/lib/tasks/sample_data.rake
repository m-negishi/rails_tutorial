namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    # create!は、ユーザが無効な場合にfalseではなく例外を発生させるので、デバッグが容易に
    User.create!(
      name: "Example User",
      email: "example@railstutorial.jp",
      password: "foobar",
      password_confirmation: "foobar"
    )

    # 根岸デバッグ用
    User.create!(
      name: "negi test",
      email: "negi@test.com",
      password: "neginegi"
      password_confirmation: "neginegi"
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
end
