class MigrateCaptainToAiAgent < ActiveRecord::Migration[7.1]
  def up
    rename_table :captain_assistant_responses, :ai_agent_topic_responses

    remove_index :ai_agent_topic_responses, name: "index_captain_assistant_responses_on_account_id"
    add_index :ai_agent_topic_responses, :account_id, name: "index_ai_agent_topic_responses_on_account_id"

    remove_index :ai_agent_topic_responses, name: "index_captain_assistant_responses_on_assistant_id"
    add_index :ai_agent_topic_responses, :account_id, name: "index_ai_agent_topic_responses_on_assistant_id"

    remove_index :ai_agent_topic_responses, name: "index_captain_assistant_responses_on_status"
    add_index :ai_agent_topic_responses, :account_id, name: "index_ai_agent_topic_responses_on_status"

  end

  def down
    rename_table :ai_agent_topic_responses, :captain_assistant_responses

    remove_index :captain_assistant_responses, name: "index_ai_agent_topic_responses_on_account_id"
    add_index :captain_assistant_responses, :account_id, name: "index_captain_assistant_responses_on_account_id"

    remove_index :captain_assistant_responses, name: "index_ai_agent_topic_responses_on_assistant_id"
    add_index :captain_assistant_responses, :account_id, name: "index_captain_assistant_responses_on_assistant_id"

    remove_index :captain_assistant_responses, name: "index_ai_agent_topic_responses_on_status"
    add_index :captain_assistant_responses, :account_id, name: "index_captain_assistant_responses_on_status"
  end

end