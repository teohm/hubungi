module ApplicationHelper

  def current_profile
    Profile.find(session[:current_profile_id].to_i)
  end
end
