FactoryBot.define do
  factory :ai_agentcopilot_thread, class: 'CopilotThread' do
    account
    user
    title { Faker::Lorem.sentence }
    topic { create(:ai_agenttopic, account: account) }
  end
end
