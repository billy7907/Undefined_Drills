class PopulateAnswersTable < ActiveRecord::Migration[5.0]
  def change

    10.times do
      User.create(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
      email: Faker::Internet.email, is_admin: false, is_validated: true, score: 0)
    end

    5.times do
      Group.create(title: Faker::Pokemon.name)
    end

    groups = Group.all
    users = User.all

    20.times do
      Drill.create(title: Faker::Hipster.sentence, description: Faker::Hacker.say_something_smart,
      level: rand(3), points: rand(500), group: groups.sample, user: users.sample )
    end

    drills = Drill.all
    40.times do
      Answer.create(body: Faker::Pokemon.name, drill: drills.sample)
    end

  end
end
