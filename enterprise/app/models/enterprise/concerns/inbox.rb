module Enterprise::Concerns::Inbox
  extend ActiveSupport::Concern

  included do
    has_one :captain_inbox, dependent: :destroy, class_name: 'CaptainInbox'
    has_one :captain_topic,
            through: :captain_inbox,
            class_name: 'Captain::Topic'
  end
end
