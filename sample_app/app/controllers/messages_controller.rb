class MessagesController < ApplicationController
  before_action :signed_in_user

  def index
    @messages = current_user.messages
    # @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def create

  end
end
