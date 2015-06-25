class MessagesController < ApplicationController
  before_action :signed_in_user

  def index
    @messages = current_user.messages
    # @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def create
    @message = current_user.messages.build(message_params)
    # binding.pry
    # (@)は不要
    # 正規表現iオプション不要
    # nameの正規表現あっているのか？
    if /(@)(\w+)/i =~ @message.content
      reply_to_user = User.find_by(name: $2)
      @message.in_reply_to = reply_to_user.id unless reply_to_user.nil?
    end

    if @message.save
      flash[:success] = "Message sended!"
      redirect_to root_url
    else
      # raise @message.inspect
      flash[:error] = "Should have whom you send"
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
