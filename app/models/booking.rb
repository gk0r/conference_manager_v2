class Booking < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :conference_number
  
  validates_presence_of :conference_number_id, :user_id, :date, :time_start, :time_finish
  
  def parse(current_user_id)
    # FIXME: For some reason the times below get stored with an extra 10 hours (UTC offset). Workout why this happens and fix it.
    self.time_start = Time.parse("#{self.date} #{self.time_start.to_s}") unless self.time_start.blank? # time_start
    self.time_finish = Time.parse("#{self.date} #{self.time_finish.to_s}") unless self.time_finish.blank? # time_finish
    self.user_id = current_user_id
  end
  
end

