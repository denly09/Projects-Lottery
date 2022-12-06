# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only:  [:create]
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
    unless cookies[:promoter]
      cookies[:promoter] = params[:promoter]
    end
  end

  # POST /resource
  def create
    params[:user][:parent_id] = User.find_by_email(cookies[:promoter])&.id
    super
  end

  # GET /resource/edit
  def edit
    super
    # flash[:notice]
  end

  # PUT /resource
  def update
    parameter = params[:user]
    if parameter[:current_password].present? || parameter[:password_confirmation].present? || parameter[:password].present?
      update_with_pass
      # flash[:notice] = ''
    else
      update_without_pass
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected
  def params_with_pass
    params.require(:user).permit(:current_password, :password_confirmation, :password)
  end

  def params_without_pass
    params.require(:user).permit(:username, :phone_number, :image, :current_password, :password_confirmation, :password)
  end

  def update_without_pass
    if params[:user][:current_password].blank?
      resource.update_without_password(params_without_pass.except(:current_password))
      redirect_to me_path
    else
      render :edit
    end
  end

  def update_with_pass
    if resource.update_with_password(params_with_pass)
      redirect_to new_user_session_path
    else
      render :edit
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    added_attrs = [:parent, :email, :phone_number, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    change = [:email, :phone_number, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit(:account_update, keys: change)
  end


  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
