class CreateAiAgentInbox < ActiveRecord::Migration[7.0]
  def change
    create_table :ai_agentinboxes do |t|
      t.references :ai_agenttopic, null: false
      t.references :inbox, null: false
      t.timestamps
    end

    add_index :ai_agentinboxes, [:ai_agenttopic_id, :inbox_id], unique: true
  end
end
