FactoryBot.define do
  factory :captain_topic_response, class: 'Captain::TopicResponse' do
    association :topic, factory: :captain_topic
    association :account
    sequence(:question) { |n| "Test question #{n}?" }
    sequence(:answer) { |n| "Test answer #{n}" }
    embedding { Array.new(1536) { rand(-1.0..1.0) } }

    trait :with_document do
      association :document, factory: :captain_document
    end
  end
end
