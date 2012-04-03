class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :telephone_number
  
  #validates_presence_of :username, :password, :first_name, :last_name, :telephone_number, :password_confirmation 
  # TODO: Do I need this validates_validates_presence_of in the user.rb model?
  

  before_validation(:on => :create) do
    self.email = self.username + '@centrelink.gov.au' unless attribute_present?("email")
  end
  
end
