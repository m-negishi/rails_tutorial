class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      # ユーザをサインインさせ、ユーザページにリダイレクト
      sign_in user
      redirect_to user
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
