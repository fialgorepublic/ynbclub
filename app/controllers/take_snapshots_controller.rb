class TakeSnapshotsController < ApplicationController
  before_action :authorize_user!

  def edit
  end

  def update
    if @snapshot.update(snapshot_params)
      redirect_to take_snapshot_path, notice: I18n.t(:update_snapshot)
    else
      render :edit
    end
  end

  def destroy
    if @snapshot.delete_avatar?(params[:id])
      redirect_to take_snapshot_path, notice: I18n.t(:picture_removed)
    else
      redirect_to edit_take_snapshots_path, alert: I18n.t(:order_update_error)
    end
  end

  def banner
    @page.update(snapshot_banner: params[:page][:snapshot_banner])
    redirect_to take_snapshot_path
  end

  private
    def snapshot_params
      params.require(:snapshot).permit(:step1_avatar, :step2_avatar, :step3_avatar, :step4_avatar, :step1_text, :step2_text, :step3_text, :step4_text)
    end
end
