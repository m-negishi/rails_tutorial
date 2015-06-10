class MicropostsController < ApplicationController
  # 今はcreateとdestroyメソッドしかないのでonlyは不要だが、今後アクションが増えることを考慮して明示的に指定
  before_action :signed_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      # root_pathと何が違う？
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy

  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
