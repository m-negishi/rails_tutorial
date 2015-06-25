class MessagesController < ApplicationController
  before_action :signed_in_user

  def index
    @messages = current_user.messages
    # @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def create
    @message = current_user.messages.build(message_params)

    if @message.save
      flash[:success] = "Message sended!"
      redirect_to root_url
    else
      redirect_to root_url
      # なぜredirect_toにしたかは、micropost_controllerのcreateアクション参照
      # @micropost = current_user.microposts.build
      # @message = current_user.messages.build
      # render 'static_pages/home'
    end
  end

  private

    def message_params
      params.require(:message).permit(:content)
    end
end
