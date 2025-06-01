module Enterprise::Concerns::Inbox
  extend ActiveSupport::Concern

  included do
    has_one :ai_agentinbox, dependent: :destroy, class_name: 'AiAgentInbox'
    has_one :ai_agenttopic,
            through: :ai_agentinbox,
            class_name: 'AiAgent::Topic'
  end
end
