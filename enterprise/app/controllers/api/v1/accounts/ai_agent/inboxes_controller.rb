class Api::V1::Accounts::AiAgent::InboxesController < Api::V1::Accounts::BaseController
  before_action :current_account
  before_action -> { check_authorization(AiAgent::Topic) }

  before_action :set_topic
  def index
    @inboxes = @topic.inboxes
  end

  def create
    inbox = Current.account.inboxes.find(topic_params[:inbox_id])
    @ai_agentinbox = @topic.ai_agentinboxes.build(inbox: inbox)
    @ai_agentinbox.save!
  end

  def destroy
    @ai_agentinbox = @topic.ai_agentinboxes.find_by!(inbox_id: permitted_params[:inbox_id])
    @ai_agentinbox.destroy!
    head :no_content
  end

  private

  def set_topic
    @topic = account_topics.find(permitted_params[:topic_id])
  end

  def account_topics
    @account_topics ||= Current.account.ai_agenttopics
  end

  def permitted_params
    params.permit(:topic_id, :id, :account_id, :inbox_id)
  end

  def topic_params
    params.require(:inbox).permit(:inbox_id)
  end
end
