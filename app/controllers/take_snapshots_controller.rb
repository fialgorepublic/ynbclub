class TakeSnapshotsController < ApplicationController
  def edit
  end

  def update
    if @snapshot.update(snapshot_params)
      redirect_to take_snapshot_path, notice: "Succeffully updated."
    else
      render :edit
    end
  end

  def destroy
    if @snapshot.delete_avatar?(params[:id])
      redirect_to take_snapshot_path, notice: "Picture removed."
    else
      redirect_to edit_take_snapshots_path, alert: "Something went wrong!."
    end
  end

  private
    def snapshot_params
      params.require(:snapshot).permit(:step1_avatar, :step2_avatar, :step3_avatar, :step4_avatar, :step1_text, :step2_text, :step3_text, :step4_text)
    end
end
