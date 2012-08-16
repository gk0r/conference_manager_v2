class User < ActiveRecord::Base
  
  has_many :bookings
  audited

  # before_validation :allow_no_password

  # This helps to serialise the model and provides me with a 'full name' 'virtual' model property
  def to_label 
    [first_name, last_name].join(" ")
  end
  
  def full_name
    to_label
  end
  
  attr_accessible :username, :password, :first_name, :last_name, :telephone_number, :as => :user
  attr_accessible :username, :password, :first_name, :last_name, :telephone_number, :admin, :admin_notifications, :as => :admin
  
  has_secure_password
  
  validates_presence_of :username, :first_name, :last_name, :telephone_number
  validates_presence_of :password, :on => :create # Do not require password validation on profile updates.
  
  validates_uniqueness_of :username
  
  def role
    self.admin ? "admin" : "user"
  end
  
  # def allow_no_password
  #     # This method allows normal users to not have a password. This is a convinience measure that is suitable for an application that resides within the safe confines of a corporate firewall
  #     Rails.logger.debug "!! 1: #{self.password.blank?} 2: #{!admin?}"
  #     if self.password.blank? and !admin?
  #       # password = " "
  #       # password_confirmation = " "
  #       # password_digest = " "
  #     end
  #   end
  
end
