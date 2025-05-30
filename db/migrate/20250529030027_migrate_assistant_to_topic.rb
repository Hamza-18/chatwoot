class MigrateAssistantToTopic < ActiveRecord::Migration[7.1]
  def up
    # update column name from assistant id to topic id in ai_agent_documents
    remove_index :copilot_threads, name: "index_copilot_threads_on_assistant_id"

    rename_column :copilot_threads, :assistant_id, :topic_id
    add_index :copilot_threads, :topic_id, name: "index_copilot_threads_on_topic_id"
  end

  def down
    # revert column name from topic id to assistant id in ai_agent_documents
    remove_index :copilot_threads, name: "index_copilot_threads_on_topic_id"

    rename_column :copilot_threads, :topic_id, :assistant_id
    add_index :copilot_threads, :assistant_id, name: "index_copilot_threads_on_assistant_id"
  end
end