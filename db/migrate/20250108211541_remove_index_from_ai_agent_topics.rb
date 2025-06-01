class RemoveIndexFromAiAgentTopics < ActiveRecord::Migration[7.0]
  def change
    remove_index :ai_agenttopics, [:account_id, :name], if_exists: true
  end
end
