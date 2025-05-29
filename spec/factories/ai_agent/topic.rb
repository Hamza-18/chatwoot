FactoryBot.define do
  factory :ai_agenttopic, class: 'AiAgent::Topic' do
    sequence(:name) { |n| "Topic #{n}" }
    description { 'Test description' }
    association :account
  end
end
