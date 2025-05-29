class AddConfigToCaptainTopic < ActiveRecord::Migration[7.0]
  def change
    add_column :captain_topics, :config, :jsonb, default: {}, null: false
  end
end
