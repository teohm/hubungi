class MyGroupsController < ApplicationController
  before_filter :require_auth

  def index
    @groups = current_profile.accounts.first.groups
  end

  def update_public_flag
    group = Group.find(params[:id])

    group.is_public = params[:is_public]
    render :json => group.save
  end
end