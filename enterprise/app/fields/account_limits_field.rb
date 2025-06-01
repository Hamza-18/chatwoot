require 'administrate/field/base'

class AccountLimitsField < Administrate::Field::Base
  def to_s
    data.present? ? data.to_json : { agents: nil, inboxes: nil, ai_agentresponses: nil, ai_agentdocuments: nil }.to_json
  end
end
