# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # POST /users/sign_in
  def create
    self.resource = warden.authenticate(scope: resource_name)
    if resource && resource.valid?
      sign_in(resource_name, resource)
      cookies[:auth_token] = { value: resource.authentication_token, httponly: true }
      render json: { auth_token: resource.authentication_token, message: 'Successfully signed in' }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  def destroy
    user = current_user
    user.authentication_token = nil
    user.save
    sign_out(resource_name)
    render json: { message: 'Successfully signed out' }, status: :ok
  end

  private

  def require_no_authentication
    # Пустая реализация, чтобы отключить перенаправление
  end
end
