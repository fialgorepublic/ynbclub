# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    resource = User.where(email: params[:resource][:email]).first
    if resource.present?
      raw_token, hashed_token = Devise.token_generator.generate(User, :reset_password_token)
      resource.reset_password_token = hashed_token
      resource.reset_password_sent_at = Time.now.utc
      if resource.save
        resource.send_reset_password_instructions
        flash[:notice] = "Reset password instructions have been sent to #{resource.email}."
        render json: { success: true }
      end
    else
      render json: { success: false, message: "User not Found" }
    end
    # super
  end

  def edit
    user = User.with_reset_password_token(params[:reset_password_token])
    @message = user.reset_password_sent_at + 2.minutes > Time.now.utc ? "" : "Request Password Token is expired. Please request a new one." if user.present?
    super
  end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
