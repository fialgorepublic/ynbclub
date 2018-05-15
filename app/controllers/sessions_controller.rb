class SessionsController < ApplicationController
  def create
    @omniauth = request.env['omniauth.auth']
    email = @omniauth.info.email
    name = @omniauth.info.name
    provider_id = @omniauth.uid
    provider = @omniauth.provider
    logger.info email.inspect
    user = User.where(:email => email).first
    if user.present?
      sign_in :user, user
      redirect_to root_url, notice: 'Signed in successfully'
    else
      redirect_to root_url, notice: 'User not found'
    end
  end

  def failure
    # flash[:alert] = t('controllers.sessions.failure', provider: pretty_name(env['omniauth.error.strategy'].name))
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