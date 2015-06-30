class MicropostsController < ApplicationController
  include MessagesHelper
  # 今はcreateとdestroyメソッドしかないのでonlyは不要だが、今後アクションが増えることを考慮して明示的に指定
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    if message?(params[:micropost][:content])
      if reply_to?(params[:micropost][:content])
        @message = current_user.messages.build(micropost_params)
        reply_message(@message)
        remove_string_d(@message)
        if @message.save
          flash[:success] = "Message sent!"
        else
          flash[:error] = 'Sorry, did not send.'
        end
      else
        flash[:error] = 'Please enter whom reply to.'
      end
      redirect_to root_url
    else
      @micropost = current_user.microposts.build(micropost_params)

      if @micropost.save
        flash[:success] = "Micropost created!"
        redirect_to root_url
      else
        @feed_items = []
        render 'static_pages/home'
      end
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      # findの場合はマイクロポストがない場合に例外が発生するが、find_byの場合はnilが返る
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    # TODO: message modelに移行するか、返信機能と共通化したい
    def reply_message(message)
      if /@(.+)[[:space:]]/ =~ message.content
        # binding.pry
        reply_to_user = User.find_by(name: $1)
        message.in_reply_to = reply_to_user.id unless reply_to_user.nil?
        # TODO: ユーザが存在しない場合の処理を追加？
      end
    end

    def remove_string_d(message)
      # TODO: 正規表現がmessages_helperと共通
      message.content.slice!(/^d\s/)
    end

end
