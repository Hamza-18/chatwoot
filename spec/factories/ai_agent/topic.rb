FactoryBot.define do
  factory :captain_topic, class: 'Captain::Topic' do
    sequence(:name) { |n| "Topic #{n}" }
    description { 'Test description' }
    association :account
  end
end
