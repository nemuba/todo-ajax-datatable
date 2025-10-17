# frozen_string_literal: true

FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    done { false }

    trait :completed do
      done { true }
    end

    trait :with_items do
      after(:create) do |todo|
        create_list(:item, 3, todo: todo)
      end
    end
  end
end
