class Profile < ActiveRecord::Base
  has_many :accounts

  validates_presence_of :email, :name

  attr_accessible :email, :name

end
