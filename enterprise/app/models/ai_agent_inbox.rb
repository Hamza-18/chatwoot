# == Schema Information
#
# Table name: ai_agentinboxes
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  ai_agenttopic_id :bigint           not null
#  inbox_id             :bigint           not null
#
# Indexes
#
#  index_ai_agentinboxes_on_ai_agenttopic_id               (ai_agenttopic_id)
#  index_ai_agentinboxes_on_ai_agenttopic_id_and_inbox_id  (ai_agenttopic_id,inbox_id) UNIQUE
#  index_ai_agentinboxes_on_inbox_id                           (inbox_id)
#
class AiAgentInbox < ApplicationRecord
  belongs_to :ai_agenttopic, class_name: 'AiAgent::Topic'
  belongs_to :inbox

  validates :inbox_id, uniqueness: true
end
