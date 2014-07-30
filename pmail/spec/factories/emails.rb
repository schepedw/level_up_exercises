require 'faker'
FactoryGirl.define do
  factory :email do |e|
    e.checked { [true, false].sample }
    e.starred { [true, false].sample }
    e.subject { Faker::Lorem.sentence(1, true, 5) }
    e.sender { Faker::Internet.email }
    e.send_date { Time.now }
    e.recipient { Faker::Name.name }
    e.body { Faker::Lorem.paragraph }
  end
end
