module Enterprise::Concerns::Account
  extend ActiveSupport::Concern

  included do
    has_many :sla_policies, dependent: :destroy_async
    has_many :applied_slas, dependent: :destroy_async
    has_many :custom_roles, dependent: :destroy_async

    has_many :ai_agenttopics, dependent: :destroy_async, class_name: 'AiAgent::Topic'
    has_many :ai_agenttopic_responses, dependent: :destroy_async, class_name: 'AiAgent::TopicResponse'
    has_many :ai_agentdocuments, dependent: :destroy_async, class_name: 'AiAgent::Document'

    has_many :copilot_threads, dependent: :destroy_async
  end
end
