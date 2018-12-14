class PagesController < ApplicationController
  def show
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to page_path
    else
      render :edit
    end
  end

  private
    def page_params
      params.require(:page).permit(:heading, :sub_heading, :image)
    end
end
