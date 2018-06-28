class UsersController < ApplicationController

  def update_email
    @user = current_user
    if params[:current_email] == @user.email
      @user.email = params[:new_email]
      if @user.save
        flash[:notice] = "Email successfully updated!"
        redirect_to acc_settings_path
      else
        flash[:alert] = @user.errors.full_messages
        redirect_to acc_settings_path
      end
    else
      flash[:alert] = "Current email doesn't match with the profile you are currently logged in!"
      redirect_to acc_settings_path
    end
  end

  def update_password
    @user = current_user
    if @user.valid_password?(params[:current_password])
      if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        flash[:notice] = "Password successfully updated!"
        redirect_to acc_settings_path
      else
        flash[:alert] = @user.errors.full_messages
        redirect_to acc_settings_path
      end
    else
      flash[:alert] = "Current password doesn't match!"
      redirect_to acc_settings_path
    end
  end

end
