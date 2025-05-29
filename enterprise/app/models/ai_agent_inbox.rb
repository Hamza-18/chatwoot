# == Schema Information
#
# Table name: captain_inboxes
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  captain_topic_id :bigint           not null
#  inbox_id             :bigint           not null
#
# Indexes
#
#  index_captain_inboxes_on_captain_topic_id               (captain_topic_id)
#  index_captain_inboxes_on_captain_topic_id_and_inbox_id  (captain_topic_id,inbox_id) UNIQUE
#  index_captain_inboxes_on_inbox_id                           (inbox_id)
#
class CaptainInbox < ApplicationRecord
  belongs_to :captain_topic, class_name: 'Captain::Topic'
  belongs_to :inbox

  validates :inbox_id, uniqueness: true
end
