FactoryGirl.define do
  factory :developer do
    name { Faker::Name.name }
    age { Faker::Number.between(1, 100) }
    github { Faker::Internet.url }

    trait :invalid do
      name { nil }
      age { -1 }
      github { 'github.com' }
    end
  end
end
