class User < ActiveRecord::Base
  
  has_many :bookings
  audited

  # This helps to serialise the model and provides me with a 'full name' 'virtual' model property
  def to_label 
    [first_name, last_name].join(" ")
  end
  
  def full_name
    to_label
  end
  
  # attr_accessible :username, :password, :first_name, :last_name, :telephone_number # FIXME: Rationalise this. I should not need all three lines of code.
  attr_accessible :username, :password, :first_name, :last_name, :telephone_number, :as => :user
  attr_accessible :username, :password, :first_name, :last_name, :telephone_number, :admin, :admin_notifications, :as => :admin
  
  has_secure_password
  
  validates_presence_of :username, :first_name, :last_name, :telephone_number
  validates_presence_of :password, :on => :create # Do not require password validation on profile updates.
  
  validates_uniqueness_of :username
  
  def role
    self.admin ? "admin" : "user"
  end
  
end
