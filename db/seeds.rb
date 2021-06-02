# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Item.destroy_all
Reservation.destroy_all
Brand.destroy_all

num_users = 3
num_items = 10
num_reservations_per_user = 2
num_brands = 6

num_users.times do
  User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: Faker::Internet.password,
    is_admin: Faker::Boolean.boolean
  )
end

users = User.all

num_brands.times do
  Brand.create(
    name: Faker::Appliance.brand
  )
end

brands = Brand.all

num_items.times do
  Item.create(
    name: Faker::Lorem.words(:number => rand(2..5)).map { |w| w.capitalize }.join(' '),
    description: Faker::Lorem.paragraphs(:number => rand(1..3)).join(" "),
    serial_number: Faker::Device.serial,
    brand: brands.sample
  )
end

items = Item.all

users.each do |user|
  num_reservations_per_user.times do
    # start = Faker::Time.between(from: rand(0..5).days.ago, to: rand(0..5).days.from_now)
    start = Faker::Time.between(from: rand(1..5).days.ago, to: Date.today, format: :default)
    user.reservations.create(
      items: items.sample(rand(2..5)),
      note: Faker::Lorem.paragraphs(:number => rand(1..2)).join(" "),
      start_time: start,
      end_time: Faker::Time.forward(days: rand(2..4))
    )
  end
end