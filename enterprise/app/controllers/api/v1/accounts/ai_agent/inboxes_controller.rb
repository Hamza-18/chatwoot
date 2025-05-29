class Api::V1::Accounts::Captain::InboxesController < Api::V1::Accounts::BaseController
  before_action :current_account
  before_action -> { check_authorization(Captain::Topic) }

  before_action :set_topic
  def index
    @inboxes = @topic.inboxes
  end

  def create
    inbox = Current.account.inboxes.find(topic_params[:inbox_id])
    @captain_inbox = @topic.captain_inboxes.build(inbox: inbox)
    @captain_inbox.save!
  end

  def destroy
    @captain_inbox = @topic.captain_inboxes.find_by!(inbox_id: permitted_params[:inbox_id])
    @captain_inbox.destroy!
    head :no_content
  end

  private

  def set_topic
    @topic = account_topics.find(permitted_params[:topic_id])
  end

  def account_topics
    @account_topics ||= Current.account.captain_topics
  end

  def permitted_params
    params.permit(:topic_id, :id, :account_id, :inbox_id)
  end

  def topic_params
    params.require(:inbox).permit(:inbox_id)
  end
end
