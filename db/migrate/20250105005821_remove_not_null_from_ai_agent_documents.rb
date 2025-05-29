class RemoveNotNullFromAiAgentDocuments < ActiveRecord::Migration[7.0]
  def change
    change_column_null :ai_agentdocuments, :name, true
  end
end
