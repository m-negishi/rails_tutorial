class UsersController < ApplicationController
  # before_actionで、actionの前に処理を実行できる
  # onlyを使うことで、特定のメソッドにだけ適用できる
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    # @users = User.all
    @users = User.paginate(page: params[:page])
  end

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

      # SessionsHelperをApplicationControllerでincludeしているので呼び出せる
      sign_in @user

      flash[:success] = "Welcome to the Sample App!"

      #redirect_to user_url(id: @user.id) と同じ挙動？
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # @user = User.find(params[:id])
    # before_actionで、correct_userメソッドを実行しており、current_user?メソッド、current_userメソッド(SessionsHelper)で、@userが定義できているので、上記は不要
  end

  def update
    # @user = User.find(params[:id])
    # editアクションと同様に上記は不要
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    # Strong Parametersを使いやすくする
    def user_params
      # admin属性は編集可能になってはならない属性なので、外してある
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before actions

    def signed_in_user
      unless signed_in?
        # 遷移しようとしていたurlを保持(SessionsHelper)
        store_location
        redirect_to signin_url, notice: 'Please sign in.'
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
