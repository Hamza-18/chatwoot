class MigrateAiAgentToAiAgent < ActiveRecord::Migration[7.1]
  def up
    # update table name for ai_agenttopic_responses and indexes
    remove_index :ai_agent_topic_responses, name: "index_ai_agenttopic_responses_on_account_id"
    remove_index :ai_agent_topic_responses, name: "index_ai_agenttopic_responses_on_topic_id"
    remove_index :ai_agent_topic_responses, name: "index_ai_agenttopic_responses_on_status"

    rename_table :ai_agenttopic_responses, :ai_agent_topic_responses
    rename_column :ai_agent_topic_responses, :topic_id, :topic_id

    add_index :ai_agent_topic_responses, :account_id, name: "index_ai_agent_topic_responses_on_account_id"
    add_index :ai_agent_topic_responses, :topic_id, name: "index_ai_agent_topic_responses_on_topic_id"
    add_index :ai_agent_topic_responses, :status, name: "index_ai_agent_topic_responses_on_status"

    # update table name for ai_agenttopics and indexes
    remove_index :ai_agent_topics, name: "index_ai_agenttopics_on_account_id"

    rename_table :ai_agenttopics, :ai_agent_topics
    add_index :ai_agent_topics, :account_id, name: "index_ai_agent_topics_on_account_id"

    # update table name for ai_agentdocuments and indexes
    remove_index :ai_agent_documents, name: "index_ai_agentdocuments_on_account_id"
    remove_index :ai_agent_documents, name:"index_ai_agentdocuments_on_topic_id_and_external_link"
    remove_index :ai_agent_documents, name:"index_ai_agentdocuments_on_topic_id"
    remove_index :ai_agent_documents, name:"index_ai_agentdocuments_on_status"

    rename_table :ai_agentdocuments, :ai_agent_documents
    rename_column :ai_agent_documents, :topic_id, :topic_id

    add_index :ai_agent_documents, :account_id, name: "index_ai_agent_documents_on_account_id"    
    add_index :ai_agent_documents, [:topic_id, :external_link],  name:"index_ai_agent_documents_on_topic_id_and_external_link", unique: true
    add_index :ai_agent_documents, :topic_id, name:"index_ai_agent_documents_on_topic_id"
    add_index :ai_agent_documents,:status, name:"index_ai_agent_documents_on_status"

    # update table name for ai_agentinboxes and indexes
    remove_index :ai_agent_inboxes, name:"index_ai_agentinboxes_on_ai_agenttopic_id_and_inbox_id"
    remove_index :ai_agent_inboxes, name: "index_ai_agentinboxes_on_ai_agenttopic_id"
    remove_index :ai_agent_inboxes, name: "index_ai_agentinboxes_on_inbox_id"

    rename_table :ai_agentinboxes, :ai_agent_inboxes
    rename_column :ai_agent_inboxes, :ai_agenttopic_id, :ai_agent_topic_id

    add_index :ai_agent_inboxes, [:ai_agent_topic_id, :inbox_id], name: "index_ai_agent_inboxes_on_ai_agent_topic_id_and_inbox_id", unique: true    
    add_index :ai_agent_inboxes, :ai_agent_topic_id, name: "index_ai_agent_inboxes_on_ai_agent_topic_id"
    add_index :ai_agent_inboxes, :inbox_id, name: "index_ai_agent_inboxes_on_inbox_id"


  end

  def down
    # revert table name for ai_agenttopic_responses and indexes
    remove_index :ai_agenttopic_responses, name: "index_ai_agent_topic_responses_on_account_id"
    remove_index :ai_agenttopic_responses, name: "index_ai_agent_topic_responses_on_topic_id"
    remove_index :ai_agenttopic_responses, name: "index_ai_agent_topic_responses_on_status"

    rename_table :ai_agent_topic_responses, :ai_agenttopic_responses
    rename_column :ai_agent_topic_responses, :topic_id, :topic_id

    add_index :ai_agenttopic_responses, :account_id, name: "index_ai_agenttopic_responses_on_account_id"
    add_index :ai_agenttopic_responses, :topic_id, name: "index_ai_agenttopic_responses_on_topic_id"
    add_index :ai_agenttopic_responses, :status, name: "index_ai_agenttopic_responses_on_status"

    # revert table name for ai_agenttopics and indexes
    remove_index :ai_agenttopics, name: "index_ai_agent_topics_on_topic_id"

    rename_table :ai_agent_topics, :ai_agenttopics
    add_index :ai_agenttopics, :account_id, name: "index_ai_agenttopics_on_account_id"

    # revert table name for ai_agentdocuments and indexes
    remove_index :ai_agentdocuments, name: "index_ai_agent_documents_on_account_id"
    remove_index :ai_agentdocuments, name:"index_ai_agent_documents_on_topic_id_and_external_link"
    remove_index :ai_agentdocuments, name:"index_ai_agent_documents_on_topic_id"
    remove_index :ai_agentdocuments, name:"index_ai_agent_documents_on_status"

    rename_table :ai_agent_documents, :ai_agentdocuments
    rename_column :ai_agent_documents, :topic_id, :topic_id

    add_index :ai_agentdocuments, :account_id, name: "index_ai_agentdocuments_on_account_id"
    add_index :ai_agentdocuments, [:topic_id, :external_link], name:"index_ai_agentdocuments_on_topic_id_and_external_link", unique: true
    add_index :ai_agentdocuments,:topic_id, name:"index_ai_agentdocuments_on_topic_id"
    add_index :ai_agentdocuments, :status, name:"index_ai_agentdocuments_on_status"

    # revert table name for ai_agentinboxes and indexes
    remove_index :ai_agentinboxes, name:"index_ai_agent_inboxes_on_ai_agent_topic_id_and_inbox_id"
    remove_index :ai_agentinboxes, name: "index_ai_agent_inboxes_on_ai_agent_topic_id"
    remove_index :ai_agentinboxes, name: "index_ai_agent_inboxes_on_inbox_id"

    rename_table :ai_agent_inboxes, :ai_agentinboxes
    rename_column :ai_agent_inboxes, :ai_agent_topic_id, :ai_agenttopic_id

    add_index :ai_agentinboxes, [:ai_agenttopic_id, :inbox_id], name: "index_ai_agentinboxes_on_ai_agenttopic_id_and_inbox_id", unique: true
    add_index :ai_agentinboxes, :ai_agenttopic_id, name: "index_ai_agentinboxes_on_ai_agenttopic_id"
    add_index :ai_agentinboxes, :inbox, name: "index_ai_agentinboxes_on_inbox_id"
  end

end