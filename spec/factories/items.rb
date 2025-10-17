# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    description { Faker::Lorem.sentence }
    status { [true, false].sample }
    association :todo

    trait :completed do
      status { true }
    end

    trait :incomplete do
      status { false }
    end
  end
end
