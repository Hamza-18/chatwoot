FactoryBot.define do
  factory :captain_copilot_thread, class: 'CopilotThread' do
    account
    user
    title { Faker::Lorem.sentence }
    topic { create(:captain_topic, account: account) }
  end
end
