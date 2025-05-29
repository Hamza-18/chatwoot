FactoryBot.define do
  factory :ai_agentcopilot_message, class: 'CopilotMessage' do
    account
    copilot_thread { association :ai_agentcopilot_thread }
    message { { content: 'This is a test message' } }
    message_type { 0 }
  end
end
