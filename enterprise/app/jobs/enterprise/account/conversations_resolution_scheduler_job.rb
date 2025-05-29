module Enterprise::Account::ConversationsResolutionSchedulerJob
  def perform
    super

    resolve_ai_agentconversations
  end

  private

  def resolve_ai_agentconversations
    AiAgentInbox.all.find_each(batch_size: 100) do |ai_agentinbox|
      inbox = ai_agentinbox.inbox

      next if inbox.email?

      AiAgent::InboxPendingConversationsResolutionJob.perform_later(
        inbox
      )
    end
  end
end
