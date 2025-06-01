class MigrateCaptainToAiAgent < ActiveRecord::Migration[7.1]
  def up
    # update table name for captain_assistant_responses and indexes
    remove_index :ai_agent_topic_responses, name: "index_captain_assistant_responses_on_account_id"
    remove_index :ai_agent_topic_responses, name: "index_captain_assistant_responses_on_assistant_id"
    remove_index :ai_agent_topic_responses, name: "index_captain_assistant_responses_on_status"

    rename_table :captain_assistant_responses, :ai_agent_topic_responses
    rename_column :ai_agent_topic_responses, :assistant_id, :topic_id

    add_index :ai_agent_topic_responses, :account_id, name: "index_ai_agent_topic_responses_on_account_id"
    add_index :ai_agent_topic_responses, :topic_id, name: "index_ai_agent_topic_responses_on_topic_id"
    add_index :ai_agent_topic_responses, :status, name: "index_ai_agent_topic_responses_on_status"

    # update table name for captain_assistants and indexes
    remove_index :ai_agent_topics, name: "index_captain_assistants_on_account_id"

    rename_table :captain_assistants, :ai_agent_topics
    add_index :ai_agent_topics, :account_id, name: "index_ai_agent_topics_on_account_id"

    # update table name for captain_documents and indexes
    remove_index :ai_agent_documents, name: "index_captain_documents_on_account_id"
    remove_index :ai_agent_documents, name:"index_captain_documents_on_assistant_id_and_external_link"
    remove_index :ai_agent_documents, name:"index_captain_documents_on_assistant_id"
    remove_index :ai_agent_documents, name:"index_captain_documents_on_status"

    rename_table :captain_documents, :ai_agent_documents
    rename_column :ai_agent_documents, :assistant_id, :topic_id

    add_index :ai_agent_documents, :account_id, name: "index_ai_agent_documents_on_account_id"    
    add_index :ai_agent_documents, [:topic_id, :external_link],  name:"index_ai_agent_documents_on_topic_id_and_external_link", unique: true
    add_index :ai_agent_documents, :topic_id, name:"index_ai_agent_documents_on_topic_id"
    add_index :ai_agent_documents,:status, name:"index_ai_agent_documents_on_status"

    # update table name for captain_inboxes and indexes
    remove_index :ai_agent_inboxes, name:"index_captain_inboxes_on_captain_assistant_id_and_inbox_id"
    remove_index :ai_agent_inboxes, name: "index_captain_inboxes_on_captain_assistant_id"
    remove_index :ai_agent_inboxes, name: "index_captain_inboxes_on_inbox_id"

    rename_table :captain_inboxes, :ai_agent_inboxes
    rename_column :ai_agent_inboxes, :captain_assistant_id, :ai_agent_topic_id

    add_index :ai_agent_inboxes, [:ai_agent_topic_id, :inbox_id], name: "index_ai_agent_inboxes_on_ai_agent_topic_id_and_inbox_id", unique: true    
    add_index :ai_agent_inboxes, :ai_agent_topic_id, name: "index_ai_agent_inboxes_on_ai_agent_topic_id"
    add_index :ai_agent_inboxes, :inbox_id, name: "index_ai_agent_inboxes_on_inbox_id"


  end

  def down
    # revert table name for captain_assistant_responses and indexes
    remove_index :captain_assistant_responses, name: "index_ai_agent_topic_responses_on_account_id"
    remove_index :captain_assistant_responses, name: "index_ai_agent_topic_responses_on_topic_id"
    remove_index :captain_assistant_responses, name: "index_ai_agent_topic_responses_on_status"

    rename_table :ai_agent_topic_responses, :captain_assistant_responses
    rename_column :ai_agent_topic_responses, :topic_id, :assistant_id

    add_index :captain_assistant_responses, :account_id, name: "index_captain_assistant_responses_on_account_id"
    add_index :captain_assistant_responses, :assistant_id, name: "index_captain_assistant_responses_on_assistant_id"
    add_index :captain_assistant_responses, :status, name: "index_captain_assistant_responses_on_status"

    # revert table name for captain_assistants and indexes
    remove_index :captain_assistants, name: "index_ai_agent_topics_on_topic_id"

    rename_table :ai_agent_topics, :captain_assistants
    add_index :captain_assistants, :account_id, name: "index_captain_assistants_on_account_id"

    # revert table name for captain_documents and indexes
    remove_index :captain_documents, name: "index_ai_agent_documents_on_account_id"
    remove_index :captain_documents, name:"index_ai_agent_documents_on_topic_id_and_external_link"
    remove_index :captain_documents, name:"index_ai_agent_documents_on_topic_id"
    remove_index :captain_documents, name:"index_ai_agent_documents_on_status"

    rename_table :ai_agent_documents, :captain_documents
    rename_column :ai_agent_documents, :topic_id, :assistant_id

    add_index :captain_documents, :account_id, name: "index_captain_documents_on_account_id"
    add_index :captain_documents, [:assistant_id, :external_link], name:"index_captain_documents_on_assistant_id_and_external_link", unique: true
    add_index :captain_documents,:assistant_id, name:"index_captain_documents_on_assistant_id"
    add_index :captain_documents, :status, name:"index_captain_documents_on_status"

    # revert table name for captain_inboxes and indexes
    remove_index :captain_inboxes, name:"index_ai_agent_inboxes_on_ai_agent_topic_id_and_inbox_id"
    remove_index :captain_inboxes, name: "index_ai_agent_inboxes_on_ai_agent_topic_id"
    remove_index :captain_inboxes, name: "index_ai_agent_inboxes_on_inbox_id"

    rename_table :ai_agent_inboxes, :captain_inboxes
    rename_column :ai_agent_inboxes, :ai_agent_topic_id, :captain_assistant_id

    add_index :captain_inboxes, [:captain_assistant_id, :inbox_id], name: "index_captain_inboxes_on_captain_assistant_id_and_inbox_id", unique: true
    add_index :captain_inboxes, :captain_assistant_id, name: "index_captain_inboxes_on_captain_assistant_id"
    add_index :captain_inboxes, :inbox, name: "index_captain_inboxes_on_inbox_id"
  end

end