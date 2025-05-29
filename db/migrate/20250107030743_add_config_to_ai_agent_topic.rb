class AddConfigToAiAgentTopic < ActiveRecord::Migration[7.0]
  def change
    add_column :ai_agenttopics, :config, :jsonb, default: {}, null: false
  end
end
