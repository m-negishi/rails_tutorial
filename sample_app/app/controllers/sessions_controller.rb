class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      # redirect_to user
      # サインイン前にアクセスのあったURLにリダイレクト
      redirect_back_or user
      # 下記のほうが自然？
      # でもテスト一部書き換え必要
      # redirect_back_or root_url
    else
      flash.now[:error] = 'Invalid email/password combination' # このままでは誤り
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
