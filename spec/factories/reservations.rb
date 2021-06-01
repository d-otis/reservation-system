FactoryBot.define do
  factory :reservation do
    start_time { DateTime.now }
    end_time { DateTime.now + 2 }
    note { Faker::Lorem.paragraphs(:number => rand(1..2)).join(" ") }
    user
  end
end