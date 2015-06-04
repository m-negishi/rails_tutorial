class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    # User.new(params[:user])は、rails4.0からエラーになった
    # params全体を初期化することは、ユーザが送信したものをまるごとUser.newに渡していることになって危険（マスアサインメントの脆弱性）
    @user = User.new(user_params) # まだ未完成
    if @user.save
      # 保存が成功した場合の処理

      flash[:success] = "Welcome to the Sample App!"

      #redirect_to user_url(id: @user.id) と同じ挙動？
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    # Strong Parametersを使いやすくする
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
