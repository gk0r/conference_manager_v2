class ConferenceNumber < ActiveRecord::Base
  
  has_many :bookings, :dependent => :destroy
  audited
  
  attr_accessible :conference_number

  def to_label 
    "#{conference_number}" 
  end  
  
  validates :conference_number, :presence => true, :uniqueness => true
  
end
