# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super do |resource|
      if resource.valid?
        cookies[:auth_token] = resource.authentication_token
        redirect_to ENV['FRONTEND_URL'], allow_other_host: true and return
      end
    end
  end

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
        ap resource.authentication_token # Для отладки хероку
        redirect_to "#{ENV['FRONTEND_URL']}/?token=#{cookies[:auth_token]}", allow_other_host: true and return
      end
    end
  end

  # def create
  #   super do |resource|
  #     if resource.valid?
  #       cookies[:auth_token] = resource.authentication_token
  #       ap "for debugging"
  #       redirect_to ENV['FRONTEND_URL'], allow_other_host: true and return
  #     end
  #   end
  # end


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

  # def after_sign_in_path_for(resource)
  #   ENV['FRONTEND_URL']
  # end
end
