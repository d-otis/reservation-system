FactoryBot.define do
  factory :brand do
    name { Faker::Appliance.brand }
  end
end