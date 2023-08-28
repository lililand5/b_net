# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super do |resource|
  #     resource.authentication_token = Devise.friendly_token
  #     resource.save
  #   end
  # end

  def create
    super do |resource|
      if resource.valid?
        cookies[:auth_token] = resource.authentication_token

        redirect_to ENV['FRONTEND_URL'] and return
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    user = current_user
    user.authentication_token = nil
    user.save
    super
  end


  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def after_sign_in_path_for(resource)
    ENV['FRONTEND_URL']
  end

  # def after_sign_out_path_for(resource_or_scope)
  #   ENV['FRONTEND_URL']
  # end
end
