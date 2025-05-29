class AddStatusToAiAgentDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :ai_agentdocuments, :status, :integer, null: false, default: 0
    add_index :ai_agentdocuments, :status
  end
end
