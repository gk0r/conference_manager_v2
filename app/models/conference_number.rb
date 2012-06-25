class ConferenceNumber < ActiveRecord::Base
  
  has_many :bookings
  audited

  def to_label 
    "#{conference_number}" 
  end  
  
  validates :conference_number, :presence => true, :uniqueness => true
  
end
