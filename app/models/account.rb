class Account < ActiveRecord::Base
  belongs_to :profile

  validates_presence_of :profile_id, :provider,
                        :identifier, :display_name,
                        :auth_type, :auth_token1

  attr_accessible :profile, :provider,
                  :identifier, :display_name,
                  :auth_type, :auth_token1, :auth_token2

  has_many :groups
end
