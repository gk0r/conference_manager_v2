class User < ActiveRecord::Base
  
  has_many :bookings
  
  def to_label 
    "#{first_name} #{last_name}" 
  end
  
  attr_accessible :username, :password, :first_name, :last_name, :telephone_number
  
  has_secure_password
  
  validates_presence_of :username, :password, :first_name, :last_name, :telephone_number
  validates_uniqueness_of :username
  
end
