class AddStatusToAiAgentTopicResponses < ActiveRecord::Migration[7.0]
  def change
    add_column :ai_agenttopic_responses, :status, :integer, default: 1, null: false
    add_index :ai_agenttopic_responses, :status
  end
end
