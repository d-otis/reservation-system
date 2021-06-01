FactoryBot.define do
  factory :item do
    name { Faker::Lorem.words(:number => rand(2..5)).map { |w| w.capitalize }.join(' ') }
    description { Faker::Lorem.paragraphs(:number => rand(1..3)).join(" ") }
    serial_number { Faker::Device.serial }
    brand
  end
end