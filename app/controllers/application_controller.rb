class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_auth
    profile_id = session[:current_profile_id]

    unless @current_user = Profile.find(profile_id.to_i)
      redirect_to auth_path
    end
  end

  def current_profile
    @current_user
  end
end
