class ConferenceNumber < ActiveRecord::Base
  
  has_many :bookings

  after_create :notify_admins
  
  def to_label 
    "#{conference_number}" 
  end  
  
  validates_presence_of :conference_number
  
  private
  
  def notify_admins
    User.where(:admin => true, :admin_notifications => true).each do |admin|
      Email.conference_number_added(admin, self, current_user).deliver
    end
  end
  
end
