class ConferenceNumber < ActiveRecord::Base
  
  has_many :bookings
  
  def to_label 
    "#{conference_number}" 
  end  
  
  validates_presence_of :conference_number
  
end
