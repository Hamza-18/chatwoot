class AddStatusToCaptainTopicResponses < ActiveRecord::Migration[7.0]
  def change
    add_column :captain_topic_responses, :status, :integer, default: 1, null: false
    add_index :captain_topic_responses, :status
  end
end
