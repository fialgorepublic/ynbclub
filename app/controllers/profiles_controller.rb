class ProfilesController < ApplicationController

  before_action :get_profile, only: [:update]

  def update
    @profile.update(profile_params)
    flash[:notice] = "Profile successfully updated!"
    redirect_to acc_settings_path
  end

  private

  def get_profile
    @profile = Profile.find_by(id: params[:id])
  end

  def profile_params
    if params[:profile][:date_of_birth].present?
      date_chunks = params[:profile][:date_of_birth].split('/')
      day = date_chunks[1]
      month = date_chunks[0]
      year = date_chunks[2]
      params[:profile][:date_of_birth] = [day, month, year].join('/')
      puts '===========================', params[:profile][:date_of_birth]
    end
    params.require(:profile).permit(:first_name, :surname, :date_of_birth, :phone_number, :gender, :address_line_1, :address_line_2, :state, :city, :zip_code, :security_number, :account_number, :acc_holder_name, :bank_name)
  end

end
