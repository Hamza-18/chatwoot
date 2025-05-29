FactoryBot.define do
  factory :captain_inbox, class: 'CaptainInbox' do
    association :captain_topic, factory: :captain_topic
    association :inbox
  end
end
