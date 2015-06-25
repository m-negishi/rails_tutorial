class MicropostsController < ApplicationController
  # 今はcreateとdestroyメソッドしかないのでonlyは不要だが、今後アクションが増えることを考慮して明示的に指定
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)

    if @micropost.save
      flash[:success] = "Micropost created!"
      # root_pathと何が違う？
      redirect_to root_url
    else
      @feed_items = []
      redirect_to root_url
      # renderで書くと、レイアウトを更新するだけなので、
      # 複数フォームを設置している場合、他方のモデルオブジェクトがnilになってしまう
      # messageモデルのformのためにリダイレクトで戻るようにした
      # @micropost = current_user.microposts.build
      # @message = current_user.messages.build
      # render 'static_pages/home'
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
end
