require 'rails_helper'

RSpec.describe Account::ConversationsResolutionSchedulerJob, type: :job do
  let(:account) { create(:account) }
  let(:topic) { create(:ai_agenttopic, account: account) }

  describe '#perform - aiAgent resolutions' do
    context 'when handling different inbox types' do
      let!(:regular_inbox) { create(:inbox, account: account) }
      let!(:email_inbox) { create(:inbox, :with_email, account: account) }

      before do
        create(:ai_agentinbox, ai_agenttopic: topic, inbox: regular_inbox)
        create(:ai_agentinbox, ai_agenttopic: topic, inbox: email_inbox)
      end

      it 'enqueues resolution jobs only for non-email inboxes with aiAgent enabled' do
        expect do
          described_class.perform_now
        end.to have_enqueued_job(AiAgent::InboxPendingConversationsResolutionJob)
          .with(regular_inbox)
          .exactly(:once)
      end

      it 'does not enqueue resolution jobs for email inboxes even with aiAgent enabled' do
        expect do
          described_class.perform_now
        end.not_to have_enqueued_job(AiAgent::InboxPendingConversationsResolutionJob)
          .with(email_inbox)
      end
    end

    context 'when inbox has no aiAgent enabled' do
      let!(:inbox_without_ai_agent) { create(:inbox, account: create(:account)) }

      it 'does not enqueue resolution jobs' do
        expect do
          described_class.perform_now
        end.not_to have_enqueued_job(AiAgent::InboxPendingConversationsResolutionJob)
          .with(inbox_without_ai_agent)
      end
    end
  end
end
