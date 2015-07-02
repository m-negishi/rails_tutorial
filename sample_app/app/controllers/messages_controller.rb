class MessagesController < ApplicationController
  before_action :signed_in_user

  def index
    # TODO: ページネーションつける
    @conversations = Conversation.feed(current_user)
  end

  def show
    @messages = current_user.message_feed(params[:id]).paginate(page: params[:page])
  end

end
