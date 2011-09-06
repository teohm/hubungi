require 'rest_client'
require 'addressable/template'
require 'hashie'

class AuthenticationController < ApplicationController
  def auth
    redirect_to authorization_request_url(callback_url)
  end

  def auth_error
    @error = params[:error]
  end

  def callback
    reset_session
    
    # handle errors
    redirect_to auth_error_path(params[:error]) if params[:error]

    # fetch access token
    auth_token = fetch_auth_token(params[:code])

    # fetch profile identifier
    name, email = fetch_user_name_and_email(auth_token.access_token)

    # sign up if profile not exists
    profile = Profile.find_by_email(email) || Profile.create(
        :email => email, :name => name)

    # add account if account not exists
    profile.accounts.where(
        :provider => 'google', :identifier => email).first || profile.accounts.create(
        :provider => 'google',
        :identifier => email,
        :display_name => email,
        :auth_type => 'oauth2',
        :auth_token1 => auth_token.access_token,
        :auth_token2 => auth_token.refresh_token
    )

    # sign in
    session[:current_profile_id] = profile.id

    redirect_to root_path
  end

  def fetch_user_name_and_email(access_token)
    json = RestClient.get(
        'https://www.google.com/m8/feeds/contacts/default/thin',
        :params => {
            :v => '3.0',
            :access_token => access_token,
            :alt => 'json',
            'max-results' => 1
        }
    )
    p hash = JSON.parse(json)

    name = hash['feed']['author'].first['name']['$t']
    email = hash['feed']['author'].first['email']['$t']

    [name, email]
  end

  def fetch_auth_token(authorization_code)
    json = RestClient.post(
      "https://accounts.google.com/o/oauth2/token",
      {
        :client_id => Rails.configuration.client_ids.google,
        :client_secret => Rails.configuration.client_secrets.google,
        :code => authorization_code,
        :redirect_uri => callback_url,
        :grant_type => 'authorization_code'
      }
    )
    hash = JSON.parse(json)
    Hashie::Mash.new(hash)
  end

  def authorization_request_url(callback_url)
    template = Addressable::Template.new(
        "https://accounts.google.com/o/oauth2/auth?{-join|&|client_id,redirect_uri,scope,response_type}"
    )
    uri = template.expand(
      :client_id => Rails.configuration.client_ids.google,
      :redirect_uri => callback_url,
      :scope => 'https://www.google.com/m8/feeds/',
      :response_type => 'code'
    )
    uri.to_s
  end
end