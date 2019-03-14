class SharedUrlsController < ApplicationController
  before_action :authenticate_user!

  def index
    @shared_urls = ShareUrl.includes(:user).shared_media_urls.paginate(page: params[:page], per_page: 100)
  end
end
