FactoryBot.define do
  factory :ai_agentinbox, class: 'AiAgentInbox' do
    association :ai_agenttopic, factory: :ai_agenttopic
    association :inbox
  end
end
