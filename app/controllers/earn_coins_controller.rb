class EarnCoinsController < ApplicationController

  def edit
    @earn_coin.point_types
  end

  def update
    if @earn_coin.update(earn_coin_params)
      redirect_to page_design_path, notice: "Changes saved successfully."
    else
      render :edit
    end
  end

  private
    def earn_coin_params
      params.require(:earn_coin).permit(:main_text, :how_earn_text, :how_spend_text, :earn_way, :coins, :price, point_types_attributes: [:id, :name, :point, :_destroy])
    end
end
