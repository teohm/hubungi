class Group < ActiveRecord::Base
  belongs_to :account

  validates_presence_of :account, :name, :identifier
  
end
