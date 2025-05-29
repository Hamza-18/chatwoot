# == Schema Information
#
# Table name: captain_topics
#
#  id          :bigint           not null, primary key
#  config      :jsonb            not null
#  description :string
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#
# Indexes
#
#  index_captain_topics_on_account_id  (account_id)
#
class Captain::Topic < ApplicationRecord
  include Avatarable

  self.table_name = 'captain_topics'

  belongs_to :account
  has_many :documents, class_name: 'Captain::Document', dependent: :destroy_async
  has_many :responses, class_name: 'Captain::TopicResponse', dependent: :destroy_async
  has_many :captain_inboxes,
           class_name: 'CaptainInbox',
           foreign_key: :captain_topic_id,
           dependent: :destroy_async
  has_many :inboxes,
           through: :captain_inboxes
  has_many :messages, as: :sender, dependent: :nullify
  has_many :copilot_threads, dependent: :destroy_async

  validates :name, presence: true
  validates :description, presence: true
  validates :account_id, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  scope :for_account, ->(account_id) { where(account_id: account_id) }

  def available_name
    name
  end

  def push_event_data
    {
      id: id,
      name: name,
      avatar_url: avatar_url.presence || default_avatar_url,
      description: description,
      created_at: created_at,
      type: 'captain_topic'
    }
  end

  def webhook_data
    {
      id: id,
      name: name,
      avatar_url: avatar_url.presence || default_avatar_url,
      description: description,
      created_at: created_at,
      type: 'captain_topic'
    }
  end

  private

  def default_avatar_url
    "#{ENV.fetch('FRONTEND_URL', nil)}/assets/images/dashboard/captain/logo.svg"
  end
end
