FactoryBot.define do
  factory :reservation do
    start_time { DateTime.now }
    end_time { DateTime.now + 2 }
    note { Faker::Lorem.paragraphs(:number => rand(1..2)).join(" ") }
    user
  end
end

def reservation_with_items(item_count: 3)
  FactoryBot.create(:reservation) do |reservation|
    FactoryBot.create_list(:item, item_count, reservations: [reservation])
  end
end