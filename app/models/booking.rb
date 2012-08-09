class Booking < ActiveRecord::Base
  attr_writer :current_step, :time_start#, :start, :finish
  
  belongs_to :user
  belongs_to :conference_number
  
  attr_accessible :user_id, :date, :time_start, :time_finish, :conference_number_id, :note, :conference_number # Core Model
  attr_accessible :start, :finish # Virtual Attributes
  
  validates_presence_of :user_id, :date, :time_start, :time_finish,                         :if => :first_step?
  validates_presence_of :conference_number_id, :user_id, :date, :time_start, :time_finish,  :if => :last_step?, :on => :save

  audited
  
  # before_validation :populate_user_id
  # before_validation :populate_correct_timestamps
  
  # def parse(current_user_id)
  #   self.date = Date.parse(self.date.to_s) unless self.date.blank? 
  #   self.time_start = Time.parse("#{self.date} #{self.time_start.to_s}") unless self.time_start.blank? 
  #   self.time_finish = Time.parse("#{self.date} #{self.time_finish.to_s}") unless self.time_finish.blank? 
  #   self.user_id = current_user_id
  # end
  
  def time_start=(time)
    @time_start = Time.zone.parse("#{date} #{time}") if time.present?
    Rails.logger.debug("!! #{@time_start} Executing time_start routine withing booking model #{date} #{time} is time.present? #{time.present?}")
  end
  
  # def time_finish=(time)
  #   self.time_finish = Time.zone.parse("#{self.date} #{time}") if time.present?
  # end
  
  def steps
    %w[one two]
  end
  
  def current_step
    @current_step || steps.first
  end
  
  def next_step
    self.current_step = steps[steps.index(current_step)+1] unless last_step?
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1] unless first_step?
  end

  def first_step?
    current_step == steps.first
  end
  
  def last_step?
    current_step == steps.last
  end
  
  def check_availability
    ConferenceNumber.find_by_sql(
      ["SELECT id, conference_number 
        FROM conference_numbers 
        WHERE id NOT IN 
          (SELECT conference_numbers.id 
            FROM conference_numbers 
            INNER JOIN bookings 
            ON conference_numbers.id=bookings.conference_number_id 
            WHERE (bookings.time_start BETWEEN ? AND ?) 
            OR (bookings.time_finish BETWEEN ? AND ?)
          )",       
      self.time_start , 
      self.time_finish - 1.second, 
      self.time_start + 1.second, 
      self.time_finish])
  end
  
  # private
  # 
  # def populate_user_id
  #   # self.user_id = audits.last.user_id if audits.last.user_id
  #   Rails.logger("!! audits.last.user_id = #{audits.last.user_id}")
  # end
  
  def start
    @start
  end
  
  def finish
    @finish
  end
  
  def populate_correct_timestamps
    self.time_start = Time.parse("#{date} #{start.to_s}") if self.start.present? 
    self.time_finish = Time.parse("#{date} #{finish.to_s}") if self.finish.present? 
  end
  
end # End of the model