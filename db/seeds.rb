# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(1..100).to_a.each do |i|
  Todo.create(
    title: Faker::Lorem.paragraph(sentence_count: 1),
    description: Faker::Lorem.paragraph(sentence_count: 2),
    done: [true, false].sample,
    items_attributes: [
      description: Faker::Lorem.paragraph(sentence_count: 1),
      status: [true, false].sample
    ]
  )
end
