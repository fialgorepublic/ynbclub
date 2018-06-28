class SessionsController < ApplicationController

  def create
    @omniauth = request.env['omniauth.auth']
    email = @omniauth.info.email
    name = @omniauth.info.name
    provider_id = @omniauth.uid
    provider = @omniauth.provider
    user_image = @omniauth.info.image
    logger.info email.inspect
    user = User.where(:email => email).first

    if user.present?
      sign_in :user, user
      begin
        if user.avatar.blank?
          user.update_attributes(:avatar => user_image) # update user profile image
        end
      rescue Exception => e
      end
      redirect_to dashboard_path, notice: 'Signed in successfully'
    else
      user = User.create(:name => name, :email => email, :password => provider_id, social_login: true)
      user.create_profile
      sign_in :user, user
      begin
        current_user.update_attributes(:avatar => user_image) # update user profile image
      rescue Exception => e
      end
      redirect_to dashboard_path, notice: 'Signed Up successfully'
    end

  end

  def failure
    render_or_redirect
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'destroy session'
  end



  def thank_you
    @discount_code = session[:discount_code]
    @status_code = session[:status_code]

  end

  protected

  def render_or_redirect
    page = thank_you_path
    if request.env['omniauth.params']['popup']
      @page = page
      render 'callback', layout: false
    else
      redirect_to page
    end
  end

  def pretty_name(provider_name)
    provider_name.titleize
  end

end