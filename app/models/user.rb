class User < ActiveRecord::Base
  
  has_many :bookings

  # This helps to serialise the model. Can't remember where....
  def to_label 
    "#{first_name} #{last_name}" 
  end
  
  attr_accessible :username, :password, :first_name, :last_name, :telephone_number # FIXME: Rationalise this. I should not need all three lines of code.
  attr_accessible :username, :password, :first_name, :last_name, :telephone_number, :as => :user
  attr_accessible :username, :password, :first_name, :last_name, :telephone_number, :admin, :as => :admin
  
  has_secure_password
  
  validates_presence_of :username, :first_name, :last_name, :telephone_number
  validates_presence_of :password, :on => :create
  
  validates_uniqueness_of :username
  
  def role
    self.admin ? "admin" : "user"
  end
  
end
